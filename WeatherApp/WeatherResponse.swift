//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 29/04/25.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeatherInfo
}

struct MainWeatherInfo: Codable {
    let temp: Double
}
