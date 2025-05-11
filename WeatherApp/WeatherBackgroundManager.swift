//
//  WeatherBackgroundManager.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 07/05/25.
//

import Foundation
import UIKit

enum WeatherBackgroundManager {

    // MARK: - Gradient Layer

    static func gradientLayer(for iconCode: String, in frame: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.name = "weatherGradient"
        gradient.frame = frame
        
        switch iconCode {
        case "01d":
            gradient.colors = [UIColor.systemBlue.cgColor, UIColor.cyan.cgColor]
        case "01n":
            gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        case "02d", "03d", "04d":
            gradient.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
        case "02n", "03n", "04n":
            gradient.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        case "09d", "10d":
            gradient.colors = [UIColor.gray.cgColor, UIColor.systemBlue.cgColor]
        case "09n", "10n":
            gradient.colors = [UIColor.darkGray.cgColor, UIColor.systemIndigo.cgColor]
        case "11d":
            gradient.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        case "11n":
            gradient.colors = [UIColor.black.cgColor, UIColor.purple.cgColor]
        case "13d":
            gradient.colors = [UIColor.white.cgColor, UIColor.systemTeal.cgColor]
        case "13n":
            gradient.colors = [UIColor.systemGray5.cgColor, UIColor.systemTeal.cgColor]
        default:
            gradient.colors = [UIColor.systemBackground.cgColor, UIColor.secondarySystemBackground.cgColor]
            
        }
        
        return gradient
    }

    // MARK: - Color Mapping

    static func colors(for iconCode: String) -> [UIColor] {
        switch iconCode {
        case "01d":
            return [UIColor.systemBlue, UIColor.cyan]
        case "01n":
            return [UIColor.black, UIColor.darkGray]
        case "02d", "03d", "04d":
            return [UIColor.lightGray, UIColor.gray]
        case "02n", "03n", "04n":
            return [UIColor.darkGray, UIColor.black]
        case "09d", "10d":
            return [UIColor.gray, UIColor.systemBlue]
        case "09n", "10n":
            return [UIColor.darkGray, UIColor.systemIndigo]
        case "11d":
            return [UIColor.darkGray, UIColor.black]
        case "11n":
            return [UIColor.black, UIColor.purple]
        case "13d":
            return [UIColor.white, UIColor.systemTeal]
        case "13n":
            return [UIColor.systemGray5, UIColor.systemTeal]
        default:
            return [UIColor.systemBackground, UIColor.secondarySystemBackground]
        }
    }
}
