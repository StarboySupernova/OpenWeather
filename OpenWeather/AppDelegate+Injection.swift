//
//  AppDelegate+Injection.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import Foundation
import Resolver //https://github.com/hmlongco/Resolver

extension Resolver: @retroactive ResolverRegistering {
  public static func registerAllServices() {
      register { HomeViewModel() }.scope(cached)
      register { WeatherManager() }.scope(unique)
  }
}
