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
