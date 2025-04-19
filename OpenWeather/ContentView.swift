//
//  ContentView.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import SwiftUI
import Resolver

struct ContentView: View {
    @InjectedObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                if let weather = homeViewModel.weather {
                    WeatherView(weather: weather)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .task {
                            DispatchQueue.main.async {
#warning("add error propagation, calling this as is, is risky")
#warning("also test this on different simulator device")
                                homeViewModel.request()
                            }
                        }
                }
                
                // Forecast view
                               switch homeViewModel.forecastState {
                               case .loading:
                                   ProgressView()
                                       .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                       .frame(maxWidth: .infinity, minHeight: 150)
                                       .padding()
                               
                               case .success(let forecast):
                                   ForecastView(forecast: forecast)
                               
                               case .failed(let error):
                                   VStack {
                                       Text("Failed to load forecast")
                                           .foregroundColor(.red)
                                       Text(error.localizedDescription)
                                           .font(.caption)
                                           .foregroundColor(.red.opacity(0.8))
                                       Button("Retry") {
                                           homeViewModel.request()
                                       }
                                       .padding()
                                       .background(Color.blue)
                                       .foregroundColor(.white)
                                       .cornerRadius(8)
                                   }
                                   .padding()
                                   .background(Color.red.opacity(0.1))
                                   .cornerRadius(10)
                               }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $homeViewModel.showModal, onDismiss: nil) {
            PermissionView() {
                homeViewModel.requestPermission()
            } dismissAction: {
                dismiss()
            }
            .background(Color.clear)
        }
        .onChange(of: homeViewModel.showModal) { newValue in
            if newValue == false {
                homeViewModel.request()
            }
        }
        .task {
            if !homeViewModel.showModal {
                homeViewModel.request()
            }
        }
    }
}

#Preview {
    ContentView()
}
