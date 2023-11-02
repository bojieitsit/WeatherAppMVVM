//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrey on 16.02.2023.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var conditiionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var locationManager: CLLocationManager!
    var viewModel: WeatherViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        viewModel = WeatherViewModel(cityName: searchTextField.text ?? "")
        bindViewModel()
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Empty")
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // обработка ошибки
        print(error)
    }

}

//MARK: - UITextFiledDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Empty")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bindViewModel()
        searchTextField.text = ""
    }
    
    
    private func bindViewModel() {
        disposeBag = DisposeBag()
        
        viewModel.temperatureText
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.conditionIcon
            .map { UIImage(systemName: $0) }
            .bind(to: conditiionImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.cityName
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
}

