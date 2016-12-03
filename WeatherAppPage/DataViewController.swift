//
//  DataViewController.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import UIKit
import CoreLocation

class DataViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var addCityButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var contraintMockViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainConditionImage: UIImageView!
    @IBOutlet weak var mainConditionLabel: UILabel!
    @IBOutlet weak var mainLowTemperatureLabel: UILabel!
    @IBOutlet weak var mainHighTemperatureLabel: UILabel!
    @IBOutlet weak var mainTemperatureLabel: UILabel!
    
    @IBOutlet weak var forecastLabel: UILabel!
    
    
    let refreshControl = UIRefreshControl()
       
    let weatherManager = WeatherManager()
    var currentCityID:String?
    var currentWeatherData:WeatherCurrent?
    var currentWeatherDaily:WeatherDaily?
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Label translation 
        forecastLabel.text = "Forecast".localized
        
        // Positionning trick - Adjust the size of the MockView in order to put correctly the weather at the bottom of the view
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        self.contraintMockViewHeight.constant = screenHeight - 217 - 24
        
        mainScrollView.delegate = self
        
        // Add a Resfresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refreshView), for: UIControlEvents.valueChanged)
        //add the refresh controll to the subview
        self.mainScrollView.insertSubview(refreshControl, at: 0)

        getWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh the view
        getWeather()
    }
    
    /*!
     Initializise the main UI component of the screen
    */
    func initView() {
        
        if currentWeatherData != nil {
            
            if currentWeatherData?.locationName != nil {
             cityNameLabel.text = currentWeatherData?.locationName
            }
            
            if currentWeatherData!.temperature != nil {
                mainTemperatureLabel.text = String.localizedStringWithFormat("%.0f °", round(currentWeatherData!.temperature!))
            }
            
            if currentWeatherData!.temperatureLow != nil {
                mainLowTemperatureLabel.text = String.localizedStringWithFormat("%.0f °", round(currentWeatherData!.temperatureLow!))
            }
            
            if currentWeatherData!.temperatureHigh != nil {
                mainHighTemperatureLabel.text = String.localizedStringWithFormat("%.0f °", round(currentWeatherData!.temperatureHigh!))
            }
            
            mainConditionLabel.text = currentWeatherData?.conditionDescription ?? ""
            
            if currentWeatherData!.icon != nil {
                mainConditionImage.image = UIImage(named:currentWeatherData!.icon!)
            }
            
            if currentWeatherData!.weatherCode != nil {
                // TODO Implement a function for SCALE TO FIT the image
                UIGraphicsBeginImageContext(self.view.frame.size)
                getBackgroundImage(currentWeatherData!.weatherCode!).draw(in: self.view.bounds)
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                self.mainView.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    /*!
     This method return the background image depending a weather condition code
     
     @param  weatherCode    Weather condition code (get from openWeather.org)
     
     @return UIImage        Background image to display
     */
    func getBackgroundImage(_ weatherCode:Int) -> UIImage {
        
        var image:UIImage? = UIImage(named:"clear")
        
        switch weatherCode {
        case 800:
            image = UIImage(named:"clear")
            break
        case 801, 802, 803, 804:
            image = UIImage(named:"cloudy")
            break
        case 500, 501, 502, 503, 504, 511, 520, 521, 522, 531:
            image = UIImage(named:"rain")
            break
        case 600, 601, 602, 611, 612, 615, 616, 620, 621, 622:
            image = UIImage(named:"snow")
            break
        case 701, 711, 721, 741 :
            image = UIImage(named:"mist")
            break
        default:
            break
        }
        
        return image!
    }
    
    /*!
     This method refresh the view when the user pull up the scrollview
     */
    func refreshView(refresh:AnyObject) {
        
        print("Pull to refresh TODO")
        
        // TODO Implement the refreshing view
        
        refreshControl.endRefreshing()
        
    }
    
   
    /*!
     This method update the current weather and forecast depending the location of the user
     */
    func updateWeatherByLocation() {
        
        // Guard if the location serbice is available
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. ")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Error CCLocation.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation = nil
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    // This is called if:
    // - the location manager is updating, and
    // - it was able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last!
        
        if currentLocation == nil {
            currentLocation = userLocation
            
            weatherManager.getWeather(byLocation: currentLocation,
                                      withUnit: kUnitMetric,
                                      withLanguage: globalCurrentLanguage,
                                      completion: { (weatherData) -> Void in
                                            DispatchQueue.main.async(execute: { () -> Void in
                    
                                                    self.currentWeatherData = weatherData
                                                    self.initView()
                                            })
                                        })
            
            weatherManager.getWeatherDaily(byLocation: currentLocation,
                                           withUnit: kUnitMetric,
                                           withLanguage: globalCurrentLanguage,
                                           completion: { (weatherData) -> Void in
                                                DispatchQueue.main.async(execute: { () -> Void in
                    
                                                        self.currentWeatherDaily = weatherData
                                                        self.forecastTableView.reloadData()
                                                    })
                                            })
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    /*!
     This method get the current weather and forescast
     */
    func getWeather() {
        if currentCityID != nil {
            if currentCityID == kCurrentLocation {
                updateWeatherByLocation()
            } else {
                updateWeatherByCityID()
            }
        }
    }
    
    /*!
     This method get the current weather by cityID
     */
    func updateWeatherByCityID() {
        
        weatherManager.getWeather(byIDCity: currentCityID!,
                                  withUnit: kUnitMetric,
                                  withLanguage: globalCurrentLanguage,
                                  completion: { (weatherData) -> Void in
                                        DispatchQueue.main.async(execute: { () -> Void in
                
                                            self.currentWeatherData = weatherData
                                            self.initView()
                                        })
                                    })
            
        weatherManager.getWeatherDaily(byIDCity: currentCityID!,
                                       withUnit: kUnitMetric,
                                       withLanguage: globalCurrentLanguage,
                                       completion: { (weatherData) -> Void in
                                            DispatchQueue.main.async(execute: { () -> Void in
            
                                                self.currentWeatherDaily = weatherData
                                                self.forecastTableView.reloadData()
                                            })
                                        })
        
    }
    
    // This is called if:
    // - the location manager is updating, and
    // - it WASN'T able to get the user's location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    //////////////////////////////////////////////////////////////////////
    // FORECAST TABLEVIEW
    //////////////////////////////////////////////////////////////////////
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ForecastTableViewCell = self.forecastTableView.dequeueReusableCell(withIdentifier: "forecastCell")! as! ForecastTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let strDate = dateFormatter.string(from: (currentWeatherDaily?.forecastDaily?[indexPath.row].date)!)
        
        cell.dayLabel.text = strDate
        cell.temperatureLowLabel.text = String.localizedStringWithFormat("%.0f °", round((currentWeatherDaily?.forecastDaily?[indexPath.row].temperatureLow)!))
        cell.temperatureHighLabel.text = String.localizedStringWithFormat("%.0f °", round((currentWeatherDaily?.forecastDaily?[indexPath.row].temperatureHigh)!))
        cell.icon.image = UIImage(named:(currentWeatherDaily?.forecastDaily?[indexPath.row].icon)!)

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentWeatherDaily != nil {
            return (currentWeatherDaily?.forecastDaily!.count)!
        }
        
        return 0
    }
    
    //////////////////////////////////////////////////////////////////////
    // IBACTION
    //////////////////////////////////////////////////////////////////////
    @IBAction func findCity() {
        
        let findViewController =  self.storyboard?.instantiateViewController(withIdentifier: "findViewID") as! FindViewController
        self.present(findViewController, animated: true, completion: nil)
        
    }

}

