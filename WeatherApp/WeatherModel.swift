//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 27/04/25.
//

import Foundation

struct WeatherModel {
    var temperature: String?
    var city: String?
    var weatherIconName: String?
    var humidity: String?
    var pressure: String?
    var windSpeed: String?
    
    init(temperature: String? = nil,
         city: String? = nil,
         weatherIconName: String? = nil,
         humidity: String? = nil,
         pressure: String? = nil,
         windSpeed: String? = nil) {
        self.temperature = temperature
        self.city = city
        self.weatherIconName = weatherIconName
        self.humidity = humidity
        self.pressure = pressure
        self.windSpeed = windSpeed
    }
    
}
