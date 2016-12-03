//
//  ListOfCities.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation

class ListOfCities {
    static let sharedInstance = ListOfCities()
    
    var cities: [String] = []
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    /*!
     This method add a city in the list of cities
     If the city already exist in the list then it is not add again
     
     @param  cityID    ID of the city to add
     */
    func add(cityID:String) {
        if !cities.contains(cityID) {
            cities.append(cityID)
        }
    }
}
