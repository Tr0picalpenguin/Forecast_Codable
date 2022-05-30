//
//  NetworkService.swift
//  Forecast_Codable
//
//  Created by Scott Cox on 5/30/22.
//

import Foundation

class WeatherNetworkService {
    
    private static let baseURLString = "https://api.weatherbit.io/v2.0/"
    
    static func fetchDays(completion: @escaping(TopLevelDictionary?) -> Void) {
        guard let baseURL = URL(string: baseURLString) else {return}
        let forecastURL = baseURL.appendingPathComponent("forecast/daily")
        
        var urlComponents = URLComponents(url: forecastURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "key", value: "8503276d5f49474f953722fa0a8e7ef8")
        let cityQuery = URLQueryItem(name: "city", value: "austin")
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        urlComponents?.queryItems = [apiQuery, cityQuery, unitsQuery]
        guard let finalURL = urlComponents?.url else {return}
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("There was an error fetching the data. The url is \(finalURL), the error is \(error.localizedDescription)")
                completion(nil)
            }
            guard let data = data else {
                print("There was an error recieving the data!")
                completion(nil)
                return
            }
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(topLevelDictionary)
            } catch {
                print("Error in all this stuff.", error.localizedDescription)
                completion(nil)
            }            
        }.resume()
    }
    
} // End of class
