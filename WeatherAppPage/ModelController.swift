//
//  ModelController.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import UIKit
import CoreLocation

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {
    
    var listOfCities = ListOfCities.sharedInstance
    
    override init() {

        super.init()

        // IF the CoreLocation is enabled THEN the first CITY to display is the CURRENT LOCATION
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("CoreLocation grant access")
                listOfCities.add(cityID: kCurrentLocation)
            }
        } else {
            print("Location services are not enabled")
        }
        
        // Add all cities save by the users
        let userSettings = UserSettings.sharedInstance
        userSettings.loadUserSettings()
        if userSettings.cityList != nil {
            for c in userSettings.cityList!{
                listOfCities.add(cityID: c)
            }
        }
        
        // TODO - BUG - temp correction
        // Bad solution for the moment because of a bug. If the number of cities is smaller than 2 is not possible to add a new city. So if the number of cities is smaller than 2 we add 2 in the list
        if listOfCities.cities.count == 0 {
            listOfCities.add(cityID: "6173331")
            listOfCities.add(cityID: "2988507")
        }
        
        if listOfCities.cities.count == 1 {
            listOfCities.add(cityID: "2988507")
        }
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.listOfCities.cities.count == 0) || (index >= self.listOfCities.cities.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.currentCityID = self.listOfCities.cities[index]
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return listOfCities.cities.index(of: viewController.currentCityID!) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.listOfCities.cities.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}

