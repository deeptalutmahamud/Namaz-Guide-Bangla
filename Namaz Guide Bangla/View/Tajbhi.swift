//
//  Tajbhi.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//

import SwiftUI

struct TajbihCounterView: View {
    @State private var count = 0
    
    var body: some View {
        ZStack {
           
            
            VStack {
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 250, height: 250)
                    
                    Text("\(count)")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                
                Spacer()
                
                VStack{
                    
                    TajbihButton(symbol: "restart.circle.fill", action: resetCount)
                        .background(
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 120, height: 120)
                        ).padding(.bottom, 50)
                    
                 
                    
                    HStack(spacing: 100) {
                        TajbihButton(symbol: "minus.circle.fill", action: decreaseCount)
                            .background(
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 120, height: 120)
                            )
                        TajbihButton(symbol: "plus.circle.fill", action: increaseCount)
                            .background(
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 120, height: 120)
                            )
                    }
                    .padding(.bottom, 90)
                }.padding(.top, 60)
                
               
            }
        }
        .onTapGesture {
            // Heavy haptic feedback on tap
            FeedbackGenerator.heavyImpactFeedback()
        }
    }
    
    private func increaseCount() {
        count += 1
        if count == 100 {
            // Heavy vibration when count reaches 100
            FeedbackGenerator.heavyVibrationFeedback()
            count = 0
        } else {
            // Heavy haptic feedback for incrementing count
            FeedbackGenerator.heavyImpactFeedback()
        }
    }
    
    private func decreaseCount() {
        if count > 0 {
            count -= 1
            // Heavy haptic feedback for decrementing count
            FeedbackGenerator.heavyImpactFeedback()
        }
    }
    
    private func resetCount(){
        count = 0
        
        FeedbackGenerator.heavyVibrationFeedback()
    }
}

struct TajbihButton: View {
    var symbol: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .clipShape(Circle())
        }
    }
}

struct FeedbackGenerator {
    static func heavyImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    static func heavyVibrationFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

struct TajbihCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TajbihCounterView()
    }
}



#Preview {
    TajbihCounterView()
}
