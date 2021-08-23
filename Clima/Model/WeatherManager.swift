//
//  WeatherManager.swift
//  Clima
//
//  Created by Fernando González on 23/08/21.
//

import Foundation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9eaa1177ef441f4d51a8a8236a191344&units=metric"
    
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
                    print(error!)
                    return // if the task has an error, stop all process with the return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
                
            }
            // Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        // decoder.decode(typeDataToDecode, DataToDecode)
        do {
            let decodedData: WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
    
}
