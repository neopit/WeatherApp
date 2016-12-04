//
//  MockSession.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-03.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import Foundation


class MockSession: URLSession {
    var completionHandler:((Data?, URLResponse?, Error?) -> Void)?
    static var mockResponse: (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }
    
    class MockTask: URLSessionDataTask {
        
        typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
        var mockResponse: Response
        let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
        
        init(response: Response, completionHandler:((Data?, URLResponse?, Error?) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }
        
        override func resume() {
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}
