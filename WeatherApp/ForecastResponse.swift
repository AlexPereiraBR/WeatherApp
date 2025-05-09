//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 09/05/25.
//

import Foundation
import SnapKit
import Alamofire

// MARK: — Model Response
struct ForecastResponse: Decodable {
  let list: [ForecastResponse.ForecastItem]
  
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

