//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrey on 16.02.2023.
//

import UIKit

class ViewController: UIViewController, UISearchTextFieldDelegate {

    @IBOutlet weak var conditiionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    // 53b959dda234fa5c8d166885b0757232 - api key
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
        
        
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Empty")
    }
    
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
       
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        
        
        
        searchTextField.text = ""
    }
    
    
}

