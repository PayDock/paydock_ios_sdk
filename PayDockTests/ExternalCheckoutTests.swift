//
//  ExternalCheckoutTests.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 13.08.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockExternalCheckoutTest: XCTestCase {
    
    let gatewayId: String = "58fdaffc74bff7153082359d"
    
    override func setUp() {
        super.setUp()
        PayDock.setSecretKey(key: "73067bb83e485b1db4f376025c38ab103d477e66")
        PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
        PayDock.shared.isSandbox = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateCheckout() {
        let expect = expectation(description: "PayDockSDK.ExternalCheckoutTest")
        let externalCheckout = ExternalCheckoutRequest(mode: "test", gatewayId: gatewayId, successRedirectUrl: "http://google.com", errorRedirectUrl: "http://google.com", description: "some description here")
        PayDock.shared.create(externalCheckout: externalCheckout) { (checkout) in
            defer { expect.fulfill() }
            do {
                let checkout = try checkout()
                debugPrint(checkout)
            } catch Errors.serverError(let message, let details, let httpStatus){
                var statusString  = String(httpStatus)
                XCTFail("Api error http status: \(statusString)  \n Error message: \(message) ")
                
            } catch let error {
                debugPrint(error)
                
                XCTFail(error.localizedDescription)
                
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    
    
    
}
