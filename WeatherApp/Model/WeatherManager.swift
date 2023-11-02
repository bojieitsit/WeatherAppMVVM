//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Andrey on 20.02.2023.
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
        
        fetchWeatherData(for: cityName)
            .map { WeatherModel(id: $0.weather[0].id, temp: $0.main.temp, name: $0.name)  }
            .subscribe(onNext: { [weak self] model in
                self?.temperatureText.onNext(model.temperatureString)
                self?.conditionIcon.onNext(model.conditionIcon)
                self?.cityName.onNext(model.name)
            }).disposed(by: disposeBag)
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        fetchWeatherData(latitude: latitude, longitude: longitude)
            .map { WeatherModel(id: $0.weather[0].id, temp: $0.main.temp, name: $0.name)  }
            .subscribe(onNext: { [weak self] model in
                self?.temperatureText.onNext(model.temperatureString)
                self?.conditionIcon.onNext(model.conditionIcon)
                self?.cityName.onNext(model.name)
            }).disposed(by: disposeBag)
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        locationManager.stopUpdatingLocation()
//        viewModel = WeatherViewModel(latitude: location.coordinate.latitude,
//                                     longitude: location.coordinate.longitude)
//        bindViewModel()
//    }
    
    
    func fetchWeatherData(for city: String) -> Observable<WeatherData> {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather"
        let appid = "53b959dda234fa5c8d166885b0757232"
        let units = "metric"
        guard let url = URL(string: endpoint + "?appid=" + appid + "&units=" + units + "&q=" + city) else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
        .map { try JSONDecoder().decode(WeatherData.self, from: $0) }    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        
        let endpoint = "https://api.openweathermap.org/data/2.5/weather"
        let appid = "53b959dda234fa5c8d166885b0757232"
        let units = "metric"
        guard let url = URL(string: endpoint + "?appid=" + appid + "&units=" + units + "&lat=" + String(latitude) + "&lon=" + String(longitude)) else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { try JSONDecoder().decode(WeatherData.self, from: $0) }
    }
    
    func bindViewModel() {
        temperatureText
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        conditionIcon
            .map { UIImage(systemName: $0) }
            .bind(to: conditiionImageView.rx.image)
            .disposed(by: disposeBag)
        
        cityName
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}

