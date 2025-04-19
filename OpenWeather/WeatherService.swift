//
//  WeatherService.swift
//  OpenWeather
//
//  Created by user276583 on 4/19/25.
//


import Foundation
import Combine
import SwiftUI

//to promote dependency injection, we need to make this class as testable as possible
protocol WeatherService {
    
    func requestForecast(from endpoint: OpenWeatherMapAPI) -> AnyPublisher<Forecast, APIError>
}

struct WeatherServiceImplementation: WeatherService {
    func requestForecast(from endpoint: OpenWeatherMapAPI) -> AnyPublisher<Forecast, APIError> {
        
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in
                APIError.errorCode(404)
            }
            .flatMap {data, response -> AnyPublisher<Forecast, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601 //the format dates are usually in
                    
                    return Just(data) //Just selected here to ensure single emission
                        .decode(type: Forecast.self, decoder: jsonDecoder)
                        .mapError { _ in
                            APIError.decodingError
                        }
                        //.print()
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }    
}
