//
//  PrayerTime.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//


import Foundation
import Combine
import CoreLocation

class PrayerTimesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var prayerTimes: [(String, String)] = []
    @Published var hijriDate: HijriDate?
    @Published var errorMessage: String?
    @Published var currentPrayerIndex: Int? // Index of the current prayer time
    @Published var qiblaDirection: Double? // Qibla direction in degrees
    
    private var service = PrayerTimesService()
    private var locationManager = CLLocationManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading() // Start heading updates
    }
    
    func getPrayerTimes(latitude: Double, longitude: Double) {
        service.fetchPrayerTimes(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let data):
                let timings = data.timings
                let prayers = [
                    ("Fajr", timings.Fajr),
                    ("Dhuhr", timings.Dhuhr),
                    ("Asr", timings.Asr),
                    ("Maghrib", timings.Maghrib),
                    ("Isha", timings.Isha)
                ]
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                let currentTime = formatter.string(from: Date())
                
                // Find the current prayer time index
                var currentIndex: Int?
                for (index, prayer) in prayers.enumerated() {
                    if currentTime < prayer.1 {
                        currentIndex = index
                        break
                    }
                }
                
                DispatchQueue.main.async {
                    self?.prayerTimes = prayers.map { ($0.0, self?.convertTo12Hour(time: $0.1) ?? "") }
                    self?.currentPrayerIndex = currentIndex
                    self?.hijriDate = data.date.hijri
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    private func convertTo12Hour(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "h:mm a"
        guard let convertedTime = date else { return "" }
        return dateFormatter.string(from: convertedTime)
    }
    
    // Qibla direction calculation
    private func calculateQiblaDirection(location: CLLocation, heading: CLHeading) -> Double {
        let kaabaLatitude = 21.4225
        let kaabaLongitude = 39.8262

        let userLatitude = location.coordinate.latitude.degreesToRadians
        let userLongitude = location.coordinate.longitude.degreesToRadians

        let deltaLongitude = (kaabaLongitude - location.coordinate.longitude).degreesToRadians

        let y = sin(deltaLongitude) * cos(kaabaLatitude.degreesToRadians)
        let x = cos(userLatitude) * sin(kaabaLatitude.degreesToRadians) - sin(userLatitude) * cos(kaabaLatitude.degreesToRadians) * cos(deltaLongitude)

        let qiblaDirection = atan2(y, x).radiansToDegrees

        let adjustedDirection = (qiblaDirection - heading.magneticHeading).truncatingRemainder(dividingBy: 360.0)
        return adjustedDirection >= 0 ? adjustedDirection : (adjustedDirection + 360)
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getPrayerTimes(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation() // Stop updating to save battery
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let location = locationManager.location {
            let qiblaDirection = calculateQiblaDirection(location: location, heading: newHeading)
            DispatchQueue.main.async {
                self.qiblaDirection = qiblaDirection
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        } else {
            errorMessage = "Location access denied."
        }
    }
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}
