//
//  compass.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var viewModel = PrayerTimesViewModel()
    
    var body: some View {
        VStack {
            if let qiblaDirection = viewModel.qiblaDirection {
                Text("Qibla Direction: \(String(format: "%.2f", qiblaDirection))°")
                    .font(.largeTitle)
                    .padding()
                
                Image(systemName: "arrow.up")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(qiblaDirection))
                    .padding()
            } else {
                Text("Calculating Qibla Direction...")
                    .font(.largeTitle)
                    .padding()
            }
            
            List(viewModel.prayerTimes, id: \.0) { prayer in
                HStack {
                    Text(prayer.0)
                    Spacer()
                    Text(prayer.1)
                }
            }
            
            if let hijriDate = viewModel.hijriDate {
                Text("Hijri Date: \(hijriDate.date) \(hijriDate.month) \(hijriDate.year)")
                    .padding()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            viewModel.requestLocation()
        }
    }
}


#Preview {
    CompassView()
}
