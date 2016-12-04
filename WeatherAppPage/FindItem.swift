//
//  FindItem.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper


class FindItem: Mappable {
    
    var cityID:Int?
    var country:String?
    var date:Date?
    var locationName:String?
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
        
        cityID                  <- map["id"]
        locationName            <- map["name"]
        country                 <- map["sys.country"]
        date                    <- (map["dt"], DateTransform())
        weatherCode             <- map["weather.0.id"]
        condition               <- map["weather.0.main"]
        conditionDescription    <- map["weather.0.description"]
        icon                    <- map["weather.0.icon"]
        temperature             <- map["main.temp"]
        temperatureHigh         <- map["main.temp_min"]
        temperatureLow          <- map["main.temp_max"]
   
    }
}
