//
//  WeatherCurrent.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-11-30.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherCurrent: Mappable {

    var cityID:Int?
    var latitude:Double?
    var longitude:Double?
    var country:String?
    var date:Date?
    var locationName:String?
    var humidity:Double?
    var temperature:Double?
    var temperatureHigh:Double?
    var temperatureLow:Double?
    var sunrise:Date?
    var sunset:Date?
    var weatherCode:Int?
    var conditionDescription:String?
    var condition:String?
    var windBearing:Double?
    var windSpeed:Double?
    var icon:String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        cityID                  <- map["id"]
        latitude                <- map["coord.lat"]
        longitude               <- map["coord.lon"]
        date                    <- (map["dt"], DateTransform())
        locationName            <- map["name"]
        humidity                <- map["main.humidity"]
        temperature             <- map["main.temp"]
        temperatureHigh         <- map["main.temp_max"]
        temperatureLow          <- map["main.temp_min"]
        sunrise                 <- (map["sys.sunrise"], DateTransform())
        sunset                  <- (map["sys.sunset"], DateTransform())
        country                 <- map["sys.country"]
        weatherCode             <- map["weather.0.id"]
        conditionDescription    <- map["weather.0.description"]
        condition               <- map["weather.0.main"]
        windBearing             <- map["wind.deg"]
        windSpeed               <- map["wind.speed"]
        icon                    <- map["weather.0.icon"]
    
    }
    
}
