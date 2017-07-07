
//
//  PayDockSessionTests.swift
//  PayDock
//
//  Created by RTA on 29/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockSessionTests: XCTestCase {
    
    let payDockSession = PayDockSession()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testUrlEncoder() {
        let url = URL(string: "www.apple.com?test=456")!
        let params: [String: Any] = [ "ids": [1,2,3,4,5,6],
            "someText": "!@#$%^&**)([] Sometext",
            "someObject": [
                "name": "somebody"
            ]
        ]
        let encodedUrl = payDockSession.encodeParametersToUrl(url: url, parameters: params)
        XCTAssertNotNil(encodedUrl, "result is nil")
        debugPrint(encodedUrl)
        
    }

    
}
