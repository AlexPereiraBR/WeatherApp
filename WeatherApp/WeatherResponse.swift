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
}

struct MainWeatherInfo: Decodable {
    let temp: Double
}

struct WeatherInfo: Decodable {
    let icon: String
}
