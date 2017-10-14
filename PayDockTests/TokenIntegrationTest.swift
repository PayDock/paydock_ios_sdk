//
//  PayDockTokenTest.swift
//  PayDock
//
//  Created by RTA on 26/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockTokenTest: XCTestCase {
 
    let gatewayId: String = "58fdaffc74bff7153082359d"
    
    override func setUp() {
        super.setUp()
        PayDock.setSecretKey(key: "")
        PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
        PayDock.shared.isSandbox = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetToken() {
        let expect = expectation(description: "PayDockSDK.TokenTest")
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
        let paymentSource = PaymentSource.bankAccount(value: account)
        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        let tokenRequest = TokenRequest(customer: customerRequest, address: address, paymentSource: paymentSource)
        PayDock.shared.create(token: tokenRequest) { (token) in
            defer { expect.fulfill() }
            do {
                let token: String = try token()
                print(token)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    
    
    
   }
