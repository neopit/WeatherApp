//
//  WeatherDaily.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-12-01.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper


class WeatherDaily: Mappable {
    
    var forecastDaily:[Forecast]?
 
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        forecastDaily                  <- map["list"]
    }
}
