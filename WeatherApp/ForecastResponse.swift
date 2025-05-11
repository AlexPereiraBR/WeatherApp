//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 09/05/25.
//

import Foundation

// MARK: - Forecast Response Model

struct ForecastResponse: Decodable {
    let list: [ForecastItem]

    struct ForecastItem: Decodable {
        let dt: TimeInterval
        let main: MainInfo
        let weather: [WeatherInfo]
    }

    struct MainInfo: Decodable {
        let temp: Double
    }

    struct WeatherInfo: Decodable {
        let icon: String
    }
}
