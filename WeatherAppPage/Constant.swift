//
//  Constant.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-12-01.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation


let kWeatherURL                     = "http://api.openweathermap.org/data/2.5/"
let kWeatherAPIKey                  = "92c5eb63e287b93b3a8722580b315fb0"
let kUnitMetric                     = "metric"

let kUserCurrentCityKey             = "userCurrentCityKey"
let kUserUnitKey                    = "userUnitKey"
let kUserListCityKey                = "userListCityKey"

let kCurrentLocation                = "CURR_LOCATION"

let globalCurrentLanguage = Locale.current.languageCode

enum EnumWeatherType {
    case current
    case daily
    case hour
    case find
}


