//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrei Bogoslovskii on 02.11.2023.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditiionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var locationManager: CLLocationManager!
    var viewModel: WeatherViewModel?
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
    
    //MARK: - Flow
    
    @IBAction func searchPressed(_ sender: UIButton) {
        viewModel = WeatherViewModel(cityName: searchTextField.text ?? "")
        bindViewModel()
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Empty")
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        bindViewModel()
    }
    
    //MARK: - bindViewModel()
    
    func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        guard let temperatureLabel = self.temperatureLabel,
              let conditiionImageView = self.conditiionImageView,
              let cityLabel = self.cityLabel
        else { return }
        
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
        viewModel = WeatherViewModel(cityName: searchTextField.text ?? "")
        bindViewModel()
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Empty")
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // Создаем новый экземпляр viewModel с полученными координатами местоположения
            viewModel = WeatherViewModel(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            bindViewModel()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Произошла ошибка при получении геолокации: \(error)")
        
        let alertController = UIAlertController(title: "Ошибка геолокации", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let retryAction = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] _ in
            self?.locationManager.requestLocation()
            self?.bindViewModel()
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

