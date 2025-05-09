//
//  WeatherIconMapper.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 08/05/25.
//

import Foundation

struct WeatherIconMapper {
    static func emoji(for iconCode: String) -> String {
        switch iconCode {
        case "01d": return "☀️"
        case "01n": return "🌙"
        case "02d", "02n": return "⛅️"
        case "03d", "03n", "04d", "04n": return "☁️"
        case "09d", "09n", "10d", "10n": return "🌧"
        case "11d", "11n": return "⛈"
        case "13d", "13n": return "❄️"
        case "50d", "50n": return "🌫"
        default: return "❔"
        }
    }
}
