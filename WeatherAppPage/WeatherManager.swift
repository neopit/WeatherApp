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
    
    // Session Configuration
    let config = URLSessionConfiguration.default
    var sessionURL:URLSession?
    
    init() {
        sessionURL = URLSession(configuration: config)
    }

    /*!
     This method build the URL for getting data from OpenWeather.org
     */
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
        case .hour:
            query += "forecast?" + trimmedString
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
    
    /*!
     This method get the current weather by CityID
     */
    func getWeather(byIDCity:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Construct query
        let query:String = "id=" + byIDCity
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherCurrent>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    /*!
     This method get the current weather by City Name
     */
    func getWeather(byName:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Construct query
        let query:String = "q=" + byName
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherCurrent>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    /*!
     This method get the current weather by Location
     */
    func getWeather(byLocation:CLLocation, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherCurrent?) -> Void) {
        
        // Construct query
        let query:String = "lat=" + String(describing: byLocation.coordinate.latitude) + "&lon=" + String(describing: byLocation.coordinate.longitude)
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.current))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherCurrent>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    
    /*!
     This method get the forecast by location
     */
    func getWeatherDaily(byLocation:CLLocation, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherDaily?) -> Void) {
        
        // Construct query
        let query:String = "lat=" + String(describing: byLocation.coordinate.latitude) + "&lon=" + String(describing: byLocation.coordinate.longitude)
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.daily))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherDaily>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    /*!
     This method get the forecast by CityID
     */

    func getWeatherDaily(byIDCity:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherDaily?) -> Void) {
        
        // Construct query
        let query:String = "id=" + byIDCity
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.daily))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherDaily>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    /*!
     This method get the 36H forecast by CityID
     */

    func getWeatherHour(byIDCity:String, withUnit:String?, withLanguage:String?, completion: @escaping (WeatherForecastNextHour?) -> Void) {
        
        // Construct query
        let query:String = "id=" + byIDCity
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.hour))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<WeatherForecastNextHour>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
    /*!
     This method find a list of city from a string passing in parameter
     */
    func find(byName:String, withUnit:String?, withLanguage:String?, completion: @escaping (FindCity?) -> Void) {
        
        // Construct query
        let query:String = "q=" + byName
        let url = URL(string: buildURLStringForWeather(query, withUnit, withLanguage, EnumWeatherType.find))
        
        // GET data from server
        let task = sessionURL!.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("error calling GET on \(url?.absoluteURL)")
                print(error!)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                guard let weatherData = Mapper<FindCity>().map(JSON: json) else {
                    print("Could no get the weather from JSON")
                    return
                }
                
                completion(weatherData)
                
            } catch {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
            
        })
        task.resume()
    }
    
}

