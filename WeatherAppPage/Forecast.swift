//
//  Forecast.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-12-01.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//


import Foundation
import ObjectMapper


class Forecast: Mappable {
    
    var date:Date?
    var weatherCode:Int?
    var condition:String?
    var conditionDescription:String?
    var icon:String?
    var temperature:Double?
    var temperatureHigh:Double?
    var temperatureLow:Double?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        date                    <- (map["dt"], DateTransform())
        weatherCode             <- map["weather.0.id"]
        condition               <- map["weather.0.main"]
        conditionDescription    <- map["weather.0.description"]
        icon                    <- map["weather.0.icon"]
        temperature             <- map["temp.day"]
        temperatureHigh         <- map["temp.min"]
        temperatureLow          <- map["temp.max"]
    
    }
}
