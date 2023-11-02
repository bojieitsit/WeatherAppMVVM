//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Andrei Bogoslovskii on 02.11.2023.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
}
