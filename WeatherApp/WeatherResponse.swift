//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 29/04/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: MainWeatherInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
}

struct MainWeatherInfo: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct WeatherInfo: Decodable {
    let icon: String
}

struct WindInfo: Decodable {
    let speed: Double
}
