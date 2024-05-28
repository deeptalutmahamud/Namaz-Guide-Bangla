//
//  ContentView.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//



// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PrayerTimesViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.prayerTimes.indices, id: \.self) { index in
                let prayerTime = viewModel.prayerTimes[index]
                let isCurrent = viewModel.currentPrayerIndex == index
                PrayerTimeRow(name: prayerTime.0, time: prayerTime.1, isCurrent: isCurrent)
            }
            
            if let hijriDate = viewModel.hijriDate {
                VStack(alignment: .leading) {
                    Text("Hijri Date: \(hijriDate.date)")
                    Text("Month: \(hijriDate.month.en) (\(hijriDate.month.ar))")
                    Text("Year: \(hijriDate.year)")
                }
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

struct PrayerTimeRow: View {
    let name: String
    let time: String
    let isCurrent: Bool
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(time)
                .foregroundColor(isCurrent ? .blue : .black)
            if isCurrent {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}







#Preview {
    ContentView()
}
