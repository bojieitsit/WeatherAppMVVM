//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Andrei Bogoslovskii on 02.11.2023.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa


class WeatherViewModel: NSObject {
    // Output
    let temperatureText: PublishSubject<String> = PublishSubject<String>()
    let conditionIcon: PublishSubject<String> = PublishSubject<String>()
    let cityName: PublishSubject<String> = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    
    init(cityName: String) {
        super.init()
        
        fetchWeatherData(for: cityName)
            .map { WeatherModel(id: $0.weather[0].id, temp: $0.main.temp, name: $0.name)  }
            .subscribe(onNext: { [weak self] model in
                self?.temperatureText.onNext(model.temperatureString)
                self?.conditionIcon.onNext(model.conditionIcon)
                self?.cityName.onNext(model.name)
            }).disposed(by: disposeBag)
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        super.init()
        
        fetchWeatherData(latitude: latitude, longitude: longitude)
            .map { WeatherModel(id: $0.weather[0].id, temp: $0.main.temp, name: $0.name)  }
            .subscribe(onNext: { [weak self] model in
                self?.temperatureText.onNext(model.temperatureString)
                self?.conditionIcon.onNext(model.conditionIcon)
                self?.cityName.onNext(model.name)
            }).disposed(by: disposeBag)
        
    }
    
    
    func fetchWeatherData(for city: String) -> Observable<WeatherData> {

        guard let url = URL(string: Constants.ServerConstants.endpoint + "?appid=" + Constants.ServerConstants.appid + "&units=" + Constants.ServerConstants.units + "&q=" + city) else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .flatMap { data -> Observable<WeatherData> in
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    return Observable.just(weatherData)
                } catch let error {
                    return Observable.error(error)
                }
            }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        
        guard let url = URL(string: Constants.ServerConstants.endpoint + "?appid=" + Constants.ServerConstants.appid + "&units=" + Constants.ServerConstants.units + "&lat=" + String(latitude) + "&lon=" + String(longitude)) else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .flatMap { data -> Observable<WeatherData> in
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    return Observable.just(weatherData)
                }
                catch let error {
                    return Observable.error(error)
                }
            }
    }
    
    
    
}

