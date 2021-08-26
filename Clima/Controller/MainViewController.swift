//
//  ViewController.swift
//  Clima
//
//  Created by Fernando González on 19/08/21.
// API KEY from OpenWeather: 9eaa1177ef441f4d51a8a8236a191344

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Init the instance of Weather Manager struct
    var weatherManager = WeatherManager()
    // Init tehe instance of CoreLocation
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Once all views did loaded, we need to request autorization
        // when the app is in Use
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        // delegamos esta clase frente weather Manager class
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    }
    

}

//MARK: - UITextFieldDelegate

/* Exetnsion to reduce the code */
// for this class MainViewController, we will extend the protocols
// Instead extend the protocols directly to the class
extension MainViewController: UITextFieldDelegate {
    
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
    
}

//MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate {
    
    // weatherManager who Notifies to MainViewController
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("Im here on didUpdate")
        DispatchQueue.main.async {
            // We trying to fetch data from Network, that can during seconds or minutes
            // and before to equal self.temperatureLabel.text = weather.temperatureString
            // we need to secure that network fetch was completed
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: "\(weather.conditionName)")
            self.cityLabel.text = weather.cityName
        }
    }
    
    // In case of Networking or JSON Decode Error
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    // This method will be called once after using
    // locationManager.requestLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // if the first element in the location does not nil
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("latitude: \(latitude)")
            print("longitude: \(longitude)")
            
            weatherManager.fetchWeather(longitude: longitude, latitude: latitude)
            
        }
    }
    
    // When an error ocurred trying fetch current Location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
