//
//  PayDockTokenTest.swift
//  PayDock
//
//  Created by Round Table Apps on 26/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockTokenTest: XCTestCase {
 
    let gatewayId: String = "58b60d8a6da7e425d6e4f6c7"
    
    override func setUp() {
        super.setUp()
        PayDock.setSecretKey(key: "")
        PayDock.setPublicKey(key: "8b2dad5fcf18f6f504685a46af0df82216781f3b")
        PayDock.shared.isSandbox = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetToken() {
        let expect = expectation(description: "PayDockSDK.TokenTest")
        let cardGatewayId: String = "58b60d8a6da7e425d6e4f6c7"
        let customerRequest = CustomerRequest(firstName: "Test_first_name", lastName: "Test_last_name", email: "Test@test.com", reference: "customer Refrence", phone: nil)
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
//        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
//        let paymentSource = PaymentSource.bankAccount(value: account)
//        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        let card = Card(gatewayId: cardGatewayId, name: "mark", number: "4444333322221111", expireMonth: 5, expireYear: 18, ccv: "123", address: address)
        let paymentSource = PaymentSource.card(value: card)
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
        self.waitForExpectations(timeout: 10000, handler: nil)
    }
    
    
    
    
   }
