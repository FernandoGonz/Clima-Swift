//
//  ViewController.swift
//  Clima
//
//  Created by Fernando González on 19/08/21.
// API KEY from OpenWeather: 9eaa1177ef441f4d51a8a8236a191344

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Init the instance of Weather Manager struct
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // delegamos esta clase frente weather Manager class
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    }

    /** Method that is called after the user typed the city in the text field */
    @IBAction func searchPressed(_ sender: Any) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    /** Delegate Method called when the User tap in Go button */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        textField.endEditing(true)
        return true
    }
    
    
    /** Delegate Method that clear the value in the TextField after endEditing() is called */
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Erasing content...")
        
        // Here is the perfect moment to call another StoryBoard :D
        
        // Calling to fetchWeather func
        if let city: String = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        } else {
            print("the search value is nil")
        }
        
        textField.text = ""
    }
    
    /** Delegate Method that allows us to validate the current text in the TextfIELD AFTER endEditing() is called */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("validating...")
        if textField.text != "" {
            return true
        } else {
            print("False validating")
            return false
        }
    }
    
    // weatherManager who Notifies to MainViewController
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("Im here on didUpdate")
        print(weather.temperatureString)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

