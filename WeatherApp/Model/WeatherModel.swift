//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrey on 20.02.2023.
//

import Foundation

struct WeatherModel {
    let id: Int
    let temp: Double
    let name: String
    
    var conditionIcon: String {
        id.conditionIcon
    }
    
    var temperatureString: String {
        String(format: "%.1f", temp)
    }
}

extension Int {
    var conditionIcon: String {
        switch self {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 801...804:
            return "cloud.bolt"
        default:
            return "sun.max"
        }
    }
}
