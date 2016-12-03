//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-11-30.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

public class WeatherManager{
    
    // GET Weather by CITY ID
    func getWeather(byIDCity:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "id=" + byIDCity
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<WeatherCurrent>().map(JSON: json)
                        //print(json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    // GET Weather by CITY ID
    func getWeather(byName:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "q=" + byName
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<WeatherCurrent>().map(JSON: json)
                        //print(json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    // GET Weather by LOCATION
    func getWeather(byLocation:CLLocation, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "lat=" + String(describing: byLocation.coordinate.latitude) + "&lon=" + String(describing: byLocation.coordinate.longitude)
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<WeatherCurrent>().map(JSON: json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }
   
    func buildURLStringForWeather(_ s:String, _ withUnit:String?, _ withLanguage:String?, _ withWeatherType:EnumWeatherType) -> String {
        
        var query:String = kWeatherURL
        
        let myString = s
        let trimmedString = myString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // Returns "Let's trim all the whitespace"
        // The call to the API depends on the type of data pass by by the EnumWeatherType
        switch withWeatherType {
            case .current:
                query += "weather?" + trimmedString
                break
            case .daily:
                query += "forecast/daily?" + trimmedString
                break
            case .find:
                 query += "find?" + trimmedString
                break
        }
        
        // Query with the unit
        if withUnit != nil  {
            query += "&units=" + withUnit!
        }
        
        // Query with the language
        if withLanguage != nil  {
            query += "&lang=" + withLanguage!
        }
        
        // Pass the API KEY
        query += "&appid=" + kWeatherAPIKey
        
        return query
    }
    
    
    // GET Weather by LOCATION
    func getWeatherDaily(byLocation:CLLocation, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherDaily?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "lat=" + String(describing: byLocation.coordinate.latitude) + "&lon=" + String(describing: byLocation.coordinate.longitude)
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.daily))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<WeatherDaily>().map(JSON: json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    // GET Weather by LOCATION
    func getWeatherDaily(byIDCity:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherDaily?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "id=" + byIDCity
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.daily))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<WeatherDaily>().map(JSON: json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    // GET Weather by LOCATION
    func find(byName:String, withUnit:String?, withLanguage:String?, completion: @escaping (FindCity?) -> Void) {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        // Load configuration into Session
        let session = URLSession(configuration: config)
        // Construct query
        let query:String = "q=" + byName
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.find))
        
        // GET data from server
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    {
                        let weatherData = Mapper<FindCity>().map(JSON: json)
                        completion(weatherData)
                    }
                } catch {
                    print("error in JSONSerialization")
                    completion(nil)
                }
            }
        })
        task.resume()
    }


    
}

