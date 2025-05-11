//
//  Constants.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 05/05/25.
//

import Foundation


struct Constants {

    // MARK: - API
    
    static let apiKey = "82b63b257fa6537513b6d200de7e71e4"
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
    static let language = "en"
    static let units = "metric"

    // MARK: - UserDefaults Keys
    
    static let savedCityKey = "savedCity"
    static let viewCitiesKey = "viewCities"
    static let viewedCitiesKey = "viewedCities"

    // MARK: - UI
    
    static let alertTitleError = "Error"
    static let alertButtonOK = "OK"
    static let fallbackWeatherIcon = "cloud.slash"
}
