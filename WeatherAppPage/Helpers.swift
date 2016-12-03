//
//  Helpers.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-03.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
