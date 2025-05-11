//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 29/04/25.
//

import Foundation

// MARK: - WeatherResponse

struct WeatherResponse: Decodable {
    let name: String
    let main: MainWeatherInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
}

// MARK: - MainWeatherInfo

struct MainWeatherInfo: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

// MARK: - WeatherInfo

struct WeatherInfo: Decodable {
    let icon: String
}

// MARK: - WindInfo

struct WindInfo: Decodable {
    let speed: Double
}
