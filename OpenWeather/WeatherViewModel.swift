//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/19/25.
//

import Foundation
import Combine

//same as before in WeatherEndPoint, we will use a protocol to keep our classes loosely coupled
//if we wanted to test, we can now create a mock of this viewmodel with ease
protocol WeatherViewModel {
    func getForecast()
}

class WeatherViewModelImplementation: ObservableObject, WeatherViewModel {
    //dependency injection. by using WeatherService protocol instead of WeatherServiceImplementation, we can inject any object into our class here as long as it conforms to WeatherService, making the concrete WeatherViewModelImplementation class and WeatherServiceImplementation class loosely coupled by adding a layer of abstraction
    
    private let service: WeatherService
    private(set) var forecast: Forecast?
    private var cancellables: AnyCancellable? //= Set<AnyCancellable>() //to store subscriptions (here, requests)
    private var weatherCancellables = Set<AnyCancellable>()
    
    //creating property based on result state that we can push to the front end
    //we are going to be listenimg to state changes
    @Published private(set) var state: ForecastState = .loading
    
    init(service: WeatherService) {
        self.service = service
    }
    
    func getForecast() {
        //self.state = .loading //this may be the problem
        
        let cancellable = service
            .requestForecast(from: .getForecast)
            .sink { res in
                switch res {
                    case .finished:
                        self.state = .success(content: self.forecast!)
                    case .failure(let error):
                        self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.forecast = response
            }
        
        self.cancellables = cancellable
        //self.cancellables.insert(cancellable)
    }
    
    
}

