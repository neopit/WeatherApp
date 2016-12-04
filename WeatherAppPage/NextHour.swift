//
//  NextHour.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-03.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper


class NextHour: Mappable {
    
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
        temperature             <- map["main.temp"]
        temperatureHigh         <- map["main.temp_max"]
        temperatureLow          <- map["main.temp_min"]
        
    }
}
