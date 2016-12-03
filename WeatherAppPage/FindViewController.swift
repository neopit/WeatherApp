//
//  FindViewController.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let weatherManager = WeatherManager()
    var citiesFound:FindCity?
    var listOfCities = ListOfCities.sharedInstance
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findTextField: UITextField!
    @IBOutlet weak var cityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findTextField.delegate = self
        // Refresh the result city list each time the user insert a character in the search field
        findTextField.addTarget(self, action: #selector(updateList), for: UIControlEvents.editingChanged)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateList() {
        weatherManager.find(byName: findTextField.text!,
                            withUnit: kUnitMetric,
                            withLanguage: globalCurrentLanguage,
                            completion: { (weatherData) -> Void in
                                            DispatchQueue.main.async(execute: { () -> Void in
                                                self.citiesFound = weatherData!
                                                self.cityTableView.reloadData()
                                        })
                            })
    }
    
    //////////////////////////////////////////////////////////////////////
    // TABLEVIEW
    //////////////////////////////////////////////////////////////////////
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FindTableViewCell = self.cityTableView.dequeueReusableCell(withIdentifier: "findCityCell")! as! FindTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.cityNameLabel.text = citiesFound?.listCity?[indexPath.row].locationName
        cell.countryLabel.text = citiesFound?.listCity?[indexPath.row].country
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if citiesFound != nil && citiesFound!.listCity != nil {
            return (citiesFound?.listCity?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Refind the city with the name and country becase the cityID return by the service FIND is not working ! Strange API !!!
        let query = (citiesFound?.listCity?[indexPath.row].locationName)! + "," + (citiesFound?.listCity?[indexPath.row].country)!
        weatherManager.getWeather(byName: query,
                                  withUnit: kUnitMetric,
                                  withLanguage: globalCurrentLanguage,
                                  completion: { (weatherData) -> Void in
                                        DispatchQueue.main.async(execute: { () -> Void in
                
                                            let tempWeatherData = weatherData
                                            // Add the new city in the current list of city
                                            self.listOfCities.add(cityID: String(describing: tempWeatherData!.cityID!))
                
                                            // Save the city in the user settings
                                            let userSettings = UserSettings.sharedInstance
                                            userSettings.setCityList(self.listOfCities.cities)
                
                                            // Close the view
                                            self.dismissView()
                                        })
                                })
    }
    
    //////////////////////////////////////////////////////////////////////
    // IBACTION
    //////////////////////////////////////////////////////////////////////
    @IBAction func editingEnded(sender:UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
