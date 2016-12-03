//
//  FindCity.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation
import ObjectMapper


class FindCity: Mappable {
    
    var listCity:[FindItem]?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        listCity                  <- map["list"]
    }
}
