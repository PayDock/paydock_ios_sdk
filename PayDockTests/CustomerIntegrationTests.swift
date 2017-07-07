//
//  PayDockCustomerTests.swift
//  PayDock
//
//  Created by RTA on 24/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockCustomerTests: XCTestCase {
    
    let gatewayId: String = "58fdaffc74bff7153082359d"
    let customerId: String = "58fde04c74bff71530823818"

    override func setUp() {
        super.setUp()
        PayDock.setSecretKey(key: "73067bb83e485b1db4f376025c38ab103d477e66")
        PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
        PayDock.shared.isSandbox = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testAddCustomer() {
        let expect = expectation(description: "PayDockSDK.CustomerTest")
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
        let paymentSource = PaymentSource.bankAccount(value: account)
        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        
        PayDock.shared.add(customer: customerRequest) { (customer) in
            defer { expect.fulfill() }
            do {
                let customer = try customer()
                debugPrint(customer)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        
        self.waitForExpectations(timeout: 1000, handler: nil)
    
    }
    
    func testGetCustomers() {
        let expect = expectation(description: "PayDockSDK.CustomerTest")
        PayDock.shared.getCustomers(with: nil) { (customers) in
            defer { expect.fulfill() }
            do {
                let customers = try customers()
                debugPrint(customers)
            } catch let error {
                debugPrint(error)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testGetCustomerItem() {
        let expect = expectation(description: "PayDockSDK.CustomerTest")
        PayDock.shared.getCustomer(with: customerId) { (customer) in
            defer { expect.fulfill() }
            do {
                let customer = try customer()
                debugPrint(customer)
            } catch let error {
                debugPrint(error)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    

    
       
}
