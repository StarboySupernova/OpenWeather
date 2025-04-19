//
//  WeatherEndpoint.swift
//  OpenWeather
//
//  Created by user276583 on 4/19/25.
//

import Foundation
import CoreLocation
import Resolver

//protocol used here to promote reusability, e.g. when using another API, when can use the same pattern here
protocol APIBuilder {
    var urlRequest: URLRequest {get}
    var baseURL: URL {get}
    var key: String {get} //API key to retrieve the resource
    //func locationProvider(latitude: Double?, longitude: Double?) -> CLLocationCoordinate2D
}

enum OpenWeatherMapAPI {
    case getForecast
    //if we have multiple endpoints for our API, we add them here
}

extension OpenWeatherMapAPI: APIBuilder {
        
    //we can now define a urlRequest, baseURL and a key for each of our cases in OpenWeatherMapAPI
    var urlRequest: URLRequest {
            return URLRequest(url: self.baseURL)
        }
        
        var baseURL: URL {
            switch self {
            case .getForecast:
                let homeViewModel = Resolver.resolve(HomeViewModel.self)
                let latitude = homeViewModel.lastSeenLocation?.coordinate.latitude ?? homeViewModel.defaultLocation.latitude
                let longitude = homeViewModel.lastSeenLocation?.coordinate.longitude ?? homeViewModel.defaultLocation.longitude
                
                return URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,alerts&units=metric&appid=\(self.key)")!
            }
        }
        
        var key: String {
            return "1a2176f7883d06ded7ca7e8dc6e19f18"
        }
    
}

