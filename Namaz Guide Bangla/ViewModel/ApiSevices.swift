//
//  ApiSevices.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//


import Foundation

class PrayerTimesService {
    func fetchPrayerTimes(latitude: Double, longitude: Double, completion: @escaping (Result<PrayerTimesData, Error>) -> Void) {
        let urlString = "https://api.aladhan.com/v1/timings?latitude=\(latitude)&longitude=\(longitude)&method=2"
        


        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

