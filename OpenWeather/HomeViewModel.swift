//
//  HomeViewModel.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import Foundation
import Combine
import MapKit
import ExtensionKit
import FirebaseFirestore
import Firebase
import SwiftUI
import FirebaseAuth
import Resolver

final class HomeViewModel: ObservableObject {
    @Injected var weatherManager: WeatherManager
    @Published var searchText : String
    @Published private(set) var debouncedSearch: String = ""
    @Published var region : MKCoordinateRegion
    @Published var showModal : Bool
    @Published var cityName : String = ""
    @Published var completions = [String]()
    
    let manager = CLLocationManager()
    
    @Published var search = ""
    
    @Published  var canSearchInternalRestaurant: Bool = false
    @Published var internalSearchButtonPressed: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var onErrorDismiss: (() -> Void)? = nil
    
    @Published var weather: ResponseBody?
    @Published var forecast: Forecast?
    @Published var forecastIsLoading: Bool = false
    @Published var forecastError: Error?
    @Published var forecastState: ForecastState = .loading
    
    init() {
        searchText = ""
        region = .init()
        showModal = manager.authorizationStatus == .notDetermined
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters //using best accuracy location in computationally expensive and battery intensive
        
        // Combine `search` and `internalSearchButtonPressed` to update `canSearchInternalRestaurant`
        Publishers.CombineLatest($search, $internalSearchButtonPressed)
            .map { search, buttonPressed in
                return search.count >= 4 && buttonPressed
            }
            .assign(to: \.canSearchInternalRestaurant, on: self)
            .store(in: &cancellables)
        
        // Automatically set `internalSearchButtonPressed` to false if `search.count` drops below 4
        $search
            .filter { $0.count < 4 } // Only react when the count drops below 4
            .sink(receiveValue: { [weak self] _ in  // Explicitly specify `receiveValue` This ensures that the correct variant of sink is chosen, which only handles incoming values and not the completion handler
                self?.internalSearchButtonPressed = false
                print("Search text length dropped below 4, internalSearchButtonPressed set to false")
            })
            .store(in: &cancellables)
        
        request()
    }
    
    func performInternalRestaurantSearch() {
        if search.count >= 4 {
            debouncedSearch = search // should possibly rename search to restaurantsearch for disambiguation purposes
        }
    }
    
    func request() {
        let location = getLocation().share()
        
        // Store all subscriptions to prevent them from being cancelled
        location
            .sink { [weak self] location in
                guard let self = self else { return }
                
                Task {
                    do {
                        // current weather
                        let weatherData = try await self.weatherManager.getCurrentWeather(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        
                        DispatchQueue.main.async {
                            self.weather = weatherData
                            print("Weather data updated for \(weatherData.name)")
                        }
                        
                        // forecast data
                        DispatchQueue.main.async {
                            self.forecastState = .loading
                        }
                        let forecastData = try await self.weatherManager.getForecast(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        
                        DispatchQueue.main.async {
                            self.forecast = forecastData
                            self.forecastState = .success(content: forecastData)
                            print("Forecast data updated for \(forecastData.city.name)")
                        }
                    } catch {
                        print("Error fetching data: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            if self.weather == nil {
                                self.showErrorAlert = true
                                self.errorTitle = "Weather Error"
                                self.errorMessage = "Failed to load weather data: \(error.localizedDescription)"
                            }
                            self.forecastState = .failed(error: error)
                            self.forecastError = error
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        // Monitor cityName changes
        $cityName
            .dropFirst()
            .sink { cityName in
                if !cityName.isEmpty {
                    print("Request successfully called for \(cityName)")
                }
            }
            .store(in: &cancellables)
    }
    
    // Add this helper method to centralize location update handling
    func updateWithLocation(_ location: CLLocation) {
        // Update region with the new location
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        // Perform reverse geocoding to get city name
        location.reverseGeocode()
            .compactMap(\.first)
            .compactMap(\.locality)
            .replaceError(with: "Loading...")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cityName in
                self?.cityName = cityName
                print("City name updated to: \(cityName)")
            }
            .store(in: &cancellables)
        
        self.request()
    }
    
    //using methods from ExtensionKit to leverage Combine to provide AuthorizationStatus publisher and avoid implementing a delegate pattern
    func requestPermission() {
        print("requestPermission called")
        
        let currentStatus = manager.authorizationStatus
        print("Current authorization status: \(currentStatus)")
        
        // Only proceed normally if we have Always authorization
        if currentStatus == .authorizedAlways {
            print("Have 'Always' authorization, proceeding normally")
            getLocation().sink { location in
                print("Got location: \(location)")
                self.updateWithLocation(location)
            }.store(in: &cancellables)
            self.showModal = false
            return
        }
        
        // When-in-use authorization - show limited functionality message
        if currentStatus == .authorizedWhenInUse {
            print("Only have 'When In Use' authorization - showing limited functionality message")
            Task {
                await setErrorWithMessage(
                    "Limited Functionality",
                    NSError(domain: "HomeVMLocation", code: 1001, userInfo: [NSLocalizedDescriptionKey: "OpenWeather works best with 'Always Allow' location access Please enable location access inside Settings App"]),
                    
                    handler: {
                        self.getLocation().sink { location in
                            self.updateWithLocation(location)
                        }.store(in: &self.cancellables)
                    }
                )
            }
            self.showModal = false
            return
        }
        
        // Otherwise request permissions
        manager
            .requestLocationAlwaysAuthorization()
            .map { [weak self] authorizationStatus in
                guard let self = self else { return false }
                
                print("New authorization status: \(authorizationStatus)")
                
                switch authorizationStatus {
                case .authorizedAlways:
                    print("Received 'Always' permission, proceeding normally")
                    self.getLocation().sink { location in
                        self.updateWithLocation(location)
                    }.store(in: &self.cancellables)
                    return false // Hide modal
                    
                case .authorizedWhenInUse:
                    print("Only received 'When In Use' permission - prompting for upgrade")
                    Task {
                        await setErrorWithMessage(
                            "Additional Permissions Requested",
                            NSError(domain: "HomeVMLocation", code: 1001, userInfo: [NSLocalizedDescriptionKey: "OpenWeather requires 'Always Allow' location access. Please tap 'Change to Always Allow' when prompted or update in Settings."]),
                            handler: {
                                // Prompt again for Always authorization
                                self.manager.requestAlwaysAuthorization()
                            }
                        )
                    }
                    return false
                    
                case .denied, .restricted:
                    print("Location access denied or restricted")
                    Task {
                        await setErrorWithMessage(
                            "Location Access Required",
                            NSError(domain: "HomeVMLocation", code: 1001, userInfo: [NSLocalizedDescriptionKey: "OpenWeather requires 'Always Allow' location access. Please tap 'Change to Always Allow' when prompted or update in Settings."]),
                            handler: {
                                // Offer to open settings
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL)
                                }
                            }
                        )
                    }
                    return false
                    
                case .notDetermined:
                    print("Location status still not determined")
                    return true // Keep showing modal
                    
                @unknown default:
                    return false
                }
            }
            .assign(to: &$showModal)
    }
    
    func getLocation () -> AnyPublisher<CLLocation, Never> {
        manager.receiveLocationUpdates(oneTime: true) //will run when app launches
            .replaceError(with: [])
            .compactMap(\.first)
            .eraseToAnyPublisher()
    }
}
