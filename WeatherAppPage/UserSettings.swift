//
//  UserSettings.swift
//  WeatherApp
//
//  Created by Peter Gartner on 2016-12-01.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation

class UserSettings {
    
    // Implement a singleton
    static let sharedInstance = UserSettings()

    var currentCity:String?
    var unit:Int?
    var cityList:[String]?
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    /*!
     This method load all the user settings
    */
    func loadUserSettings() {
        currentCity = UserDefaults.standard.string(forKey:kUserCurrentCityKey)
        unit = UserDefaults.standard.integer(forKey:kUserUnitKey)
        cityList = UserDefaults.standard.stringArray(forKey: kUserListCityKey) ?? [String]()
    }
    
    func setCurrentCity(_ newValue:String) {
        currentCity = newValue
        UserDefaults.standard.set(newValue, forKey: kUserCurrentCityKey)
    }
    
    func setCityList(_ newValue:[String]) {
        
        cityList = newValue
        
        // Remove the current location of the list. It is not necessary to save it because the user can move
        if cityList!.count >= 1 && cityList![0] == kCurrentLocation {
            cityList!.remove(at: 0)
        }
        UserDefaults.standard.set(cityList, forKey: kUserListCityKey)
    }
}

