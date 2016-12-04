//
//  WeatherManagerTest.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-03.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import XCTest
@testable import WeatherAppPage

class WeatherManagerTest: XCTestCase {
    
    var weatherManager = WeatherManager()
  
    let session = MockSession()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUnitIsNotPresentInURL() {
        let URLString = weatherManager.buildURLStringForWeather("", nil, nil, EnumWeatherType.current)
        XCTAssertFalse(URLString.contains("&units="))
    }
    
    func testUnitIsPresentInURL() {
        
        let URLString = weatherManager.buildURLStringForWeather("", "metric", nil, EnumWeatherType.current)
        XCTAssertTrue(URLString.contains("&units=metric"))
    }
    
    func testLanguageIsNotPresentInURL() {
        
        let URLString = weatherManager.buildURLStringForWeather("", nil, nil, EnumWeatherType.current)
        XCTAssertFalse(URLString.contains("&lang="))
    }
    
    func testLanguageIsPresentInURL() {
        let URLString = weatherManager.buildURLStringForWeather("", nil, "en", EnumWeatherType.current)
        XCTAssertTrue(URLString.contains("&lang=en"))
    }
    
    func testCityIDIsTrimmed() {
        let URLString = weatherManager.buildURLStringForWeather("  12345 3    4 k 44 ", nil, nil, EnumWeatherType.current)
        XCTAssertTrue(URLString.contains("12345 3    4 k 44"))
    }
    
    func testURLForWeatherTypeEnumEgalCurrent() {
        let URLString = weatherManager.buildURLStringForWeather("12345", nil, nil, EnumWeatherType.current)
        XCTAssertTrue(URLString.contains("weather?"))
    }
    
    func testURLForWeatherTypeEnumEgalDaily() {
        let URLString = weatherManager.buildURLStringForWeather("12345", nil, nil, EnumWeatherType.daily)
        XCTAssertTrue(URLString.contains("forecast/daily?"))
    }
    
    func testURLForWeatherTypeEnumEgalHour() {
        let URLString = weatherManager.buildURLStringForWeather("12345", nil, nil, EnumWeatherType.hour)
        XCTAssertTrue(URLString.contains("forecast?"))
    }
    
    func testURLForWeatherTypeEnumEgalFind() {
        let URLString = weatherManager.buildURLStringForWeather("12345", nil, nil, EnumWeatherType.find)
        XCTAssertTrue(URLString.contains("find?"))
    }
    
    func testURLContainApiKey() {
        let URLString = weatherManager.buildURLStringForWeather("12345", nil, nil, EnumWeatherType.find)
        XCTAssertTrue(URLString.contains(kWeatherAPIKey))
    }
    
    func testURLFull() {
        let URLString = weatherManager.buildURLStringForWeather("12345", kUnitMetric, "en", EnumWeatherType.current)
        
        let URLShouldBe = kWeatherURL + "weather?12345&units=metric&lang=en&appid=" + kWeatherAPIKey
        XCTAssertEqual(URLString, URLShouldBe,
                       "String should be \(URLShouldBe)")
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////
    // TODO WRITTING TEST IN PROGRESS
    // ThE idea is to Mock the URL session in order to simulate the call
    // We will use a local JSON file in order to evaluate if the function we would like to tst work and return the data or failed etc etc ...
    ///////////////////////////////////////////////////////////////////////////////////////
    func testRetrieveProductsValidResponse() {
        // we have a locally stored Weather forecast  in JSON format to test against.
        let testBundle = Bundle(for: type(of: self))
        let filepath = testBundle.path(forResource: "weatherTest", ofType: "json")
        let data = NSData(contentsOfFile: filepath!)
        let urlResponse = HTTPURLResponse(url: NSURL(string: kWeatherURL + "weather?q=Vancouver&units=metric&lang=en&appid=" + kWeatherAPIKey)! as URL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        var currentWeatherData:WeatherCurrent?
        
        // setup our mock response with the above data and fake response.
        MockSession.mockResponse = (data as Data?, urlResponse: urlResponse, error: nil)
        
        weatherManager.sessionURL = MockSession()
        
        weatherManager.getWeather(byName: "Vancouver", withUnit: nil, withLanguage: nil, completion: { (weatherData) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                
                currentWeatherData = weatherData
            })
        })
        
        // TODO write the assertion
    }
    
}
