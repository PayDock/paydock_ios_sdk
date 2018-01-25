//
//  PayDockTests.swift
//  PayDockTests
//
//  Created by Round Table Apps on 10/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock

class PayDockChargeTests: XCTestCase {
    
    
    let chargeId: String = "58fdc65674bff715308237be"
    var archiveChargeId: String = "58fdc65674bff715308237be"
    let gatewayId: String = "58fdaffc74bff7153082359d"
    let cardGatewayId: String = "5620de31361b787230cb7d74"
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

    
    
    ///add charge with credit card
    func testAddChargeWithCreditCard() {
        let address = Address(line1: "123 Forest Road", line2: nil, city: "Sydney", postcode: "1234", state: "NSW", country: "AUS")
        let card = Card(gatewayId: cardGatewayId, name: "Robert Davies", number: "5520000000000000", expireMonth: 12, expireYear: 18, ccv: "123", address: address)
        let paymentSource = PaymentSource.card(value: card)
        let customerRequest = CustomerRequest(firstName: "Justin", lastName: "James", email: "Test@test.com", reference: nil, phone: nil, paymentSource: paymentSource)
        let chargeRequest = ChargeRequest(amount: 10, currency: "AUD", reference: nil, description: "some charge description", customer: customerRequest)
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        PayDock.shared.add(charge: chargeRequest, completion: { (charge) in
            defer { expect.fulfill() }
            do {
                let charge = try charge()
                debugPrint(charge)
                self.archiveChargeId = charge.id!
            } catch let error {
                debugPrint(error)
                XCTFail(error.localizedDescription)
            }
        })
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    /// add charge with bank account
    func testAddChargeWithBankAccount() {
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
        let paymentSource = PaymentSource.bankAccount(value: account)
        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        let chargeRequest = ChargeRequest(amount: 10, currency: "AUD", reference: "some charge reference", description: "some charge description", customer: customerRequest)
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        PayDock.shared.add(charge: chargeRequest, completion: { (charge) in
            defer { expect.fulfill() }
            do {
                let charge = try charge()
                debugPrint(charge)
                self.archiveChargeId = charge.id!
            } catch let error {
                debugPrint(error)
                XCTFail(error.localizedDescription)
            }
        })
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    /// add charge with customer id
    func testAddChargeWithCustomerId() {
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        let request = ChargeRequest(amount: 100, currency: "AUD", reference: nil, description: nil, customerId: customerId)
        PayDock.shared.add(charge: request) { (charge) in
            defer { expect.fulfill() }
            do {
                let charge = try charge()
                debugPrint(charge)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testGetAllCharges() {
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        PayDock.shared.getCharges(with: nil) { (result) in
            defer { expect.fulfill() }
            do {
                let charges = try result()
                debugPrint(charges)
                
            } catch let error {
                print(error)
                XCTFail(error.localizedDescription)
            }
            
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    
    func testGetCharge() {
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        PayDock.shared.getCharge(with: chargeId) { (charge) in
            defer { expect.fulfill() }
            do {
                let charge = try charge()
                debugPrint(charge)
                
            } catch let error {
                print(error)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testArchiveCharge() {
        let expect = expectation(description: "PayDockSDK.ChargeTest")
        PayDock.shared.archiveCharge(with: archiveChargeId) { (charge) in
            defer { expect.fulfill() }
            do {
                let charge = try charge()
                debugPrint(charge)
                
            } catch let error {
                print(error)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
        
    }
}
