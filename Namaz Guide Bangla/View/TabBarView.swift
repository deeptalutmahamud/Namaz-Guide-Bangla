//
//  TabBarView.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 2
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedTab) {
                
                    ContentView()
                        .tabItem {
                            VStack {
                                Image(systemName: "calendar.circle")
                                    .imageScale(.medium)
                                Text("Upcoming")
                            }
                        }
                        .tag(0)
                    
                    
                    TajbihCounterView()
                        .tabItem {
                            VStack {
                                Image(systemName: "livephoto.play")
                                    .imageScale(.medium)
                                Text("LiveTV")
                            }
                        }
                        .tag(1)
                    
                    
                    CompassView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                    .imageScale(.medium)
                                Text("Home")
                                
                            }
                            
                        }
                        .tag(2)
                   
                        .tabItem {
                            VStack {
                                Image(systemName: "film")
                                    .imageScale(.medium)
                                Text("Watchlist")
                            }
                        }
                        .tag(3)
                    
                  
                        .tabItem {
                            VStack {
                                Image(systemName: "person")
                                    .imageScale(.medium)
                                Text("Account")
                            }
                        }
                        .tag(4)
                }
                .accentColor(Color.blue)
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
            }
        }
    }
}

#Preview {
    TabBarView()
}
