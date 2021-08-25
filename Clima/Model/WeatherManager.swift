//
//  WeatherManager.swift
//  Clima
//
//  Created by Fernando González on 23/08/21.
//

import Foundation
// Por convención en Swift, el protocolo va en la misma clase que notificará al delegado
protocol WeatherManagerDelegate {
    // weatherManager who notifies to a delegate class
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9eaa1177ef441f4d51a8a8236a191344&units=metric"
    
    // The delegate will do an UpdateWeather
    var delegate: WeatherManagerDelegate?
    
    
    /** Method that allow us fetching Weather by cityName: String from OpenWeather*/
    func fetchWeather(cityName: String) {
        
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        
        self.performRequest(urlString: urlString)
    }
    
    /** This method allows to create a Networking */
    func performRequest(urlString: String) {
        // Step 1: Creating the URL
        if let url: URL = URL(string: urlString) { // if url is not  nil
            // Step 2: Creating the URL Session
            let session: URLSession = URLSession(configuration: .default)
            // Step 3: Giving the session a task
            // Once the task is completed, the same task calls the completionHandler
            let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    // print(error!)
                    // if an error exists Networking, WeatherManager notifies to delegate (MainViewController)
                    self.delegate?.didFailWithError(error: error!)
                    return // if the task has an error, stop all process with the return
                }
                
                if let safeData = data {
                    if let weather: WeatherModel = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            }
            // Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // decoder.decode(typeDataToDecode, DataToDecode)
        do {
            let decodedData: WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].id)
            
            let id: Int = decodedData.weather[0].id
            let name: String = decodedData.name
            let temp: Double = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName)
            
            return weather
            
        } catch {
            // print(error)
            // if an error exists decoding JSON, notifies to delegate
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
