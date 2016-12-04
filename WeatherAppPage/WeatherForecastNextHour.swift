//
//  WeatherForecastNextHour.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-03.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation


import ObjectMapper


class WeatherForecastNextHour: Mappable {
    
    var nextHours:[NextHour]?
    var index12H:Int?
    var index24H:Int?
    var index36H:Int?

    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        nextHours                  <- map["list"]
        
        // TODO - calculate the index with the date not approximatively with the index position * 3 hours
        if nextHours != nil && nextHours!.count >= 11 {
            self.index12H = 3
            self.index24H = 7
            self.index36H = 11
        }
    }
    
    func getNext12H() -> NextHour? {
        if nextHours != nil && index12H != nil {
            return nextHours?[self.index12H!]
        }
        
        return nil
    }
    
    func getNext24H() -> NextHour? {
        if nextHours != nil && index24H != nil {
            return nextHours?[self.index24H!]
        }
        
        return nil
    }
    
    func getNext36H() -> NextHour? {
        if nextHours != nil && index36H != nil {
            return nextHours?[self.index36H!]
        }
        
        return nil
    }
}
