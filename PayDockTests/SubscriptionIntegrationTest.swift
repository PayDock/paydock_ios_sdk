//
//  PayDockSubscriptionTest.swift
//  PayDock
//
//  Created by RTA on 26/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock
class PayDockSubscriptionTest: XCTestCase {
  
    let gatewayId: String = "58fdaffc74bff7153082359d"
    let subscriptionId: String = "5900525674bff71530823f5d"
    
    override func setUp() {
        super.setUp()
        PayDock.setSecretKey(key: "73067bb83e485b1db4f376025c38ab103d477e66")
        PayDock.setPublicKey(key: "1b0496942b784d96b660d01542aa0ceba45dd9e9")
        PayDock.shared.isSandbox = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateSubscriptionWithCustomer() {
        let expect = expectation(description: "PayDockSDK.SubscriptionTest")
        let schedule = Schedule(interval: "day", frequency: 7, startDate: nil, endDate: nil, endAmountAfter: nil, endAmountBefore: nil, endAmountTotal: nil, endTransactions: nil)
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
        let paymentSource = PaymentSource.bankAccount(value: account)
        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        let subscriptionRequest = SubscriptionRequest(amount: 1, currency: "AUD", reference: "ref", description: "desc", customer: customerRequest, schedule: schedule)
        PayDock.shared.add(subscription: subscriptionRequest) { (sub) in
            defer { expect.fulfill() }
            do {
                let sub = try sub()
                debugPrint(sub)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
        
    }
    
    func testGetSubscriptions() {
        let expect = expectation(description: "PayDockSDK.SubscriptionTest")
        PayDock.shared.getsubscriptions(with: nil) { (subs) in
            defer { expect.fulfill() }
            do {
                let subs = try subs()
                print(subs)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testGetSubscription() {
        let expect = expectation(description: "PayDockSDK.SubscriptionTest")
        PayDock.shared.getSubscription(with: subscriptionId) { (sub) in
            defer { expect.fulfill() }
            do {
                let sub = try sub()
                debugPrint(sub)
            } catch let error {
                debugPrint(error.localizedDescription)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testUpdateSubscription() {
        let expect = expectation(description: "PayDockSDK.SubscriptionTest")
        let schedule = Schedule(interval: "month", frequency: 7, startDate: Date(), endDate: nil, endAmountAfter: nil, endAmountBefore: nil, endAmountTotal: nil, endTransactions: nil)
        let address = Address(line1: "one", line2: "two", city: "city", postcode: "1234", state: "state", country: "AU")
        let account = BankAccount(gatewayId: gatewayId, accountNumber: "411111111111111",accountName: "Test User", bankName: "Bank of Australia", accountRouting: "123123", holderType: "personal", address: address, type: "savings")
        let paymentSource = PaymentSource.bankAccount(value: account)
        let customerRequest = CustomerRequest(firstName: "Promise name", lastName: "Promise last name", email: "Test@test.com", reference: "AUS", phone: nil, paymentSource: paymentSource)
        let subscriptionRequest = SubscriptionRequest(amount: 1, currency: "AUD", reference: "ref", description: "desc", customer: customerRequest, schedule: schedule)
        PayDock.shared.update(subscription: subscriptionRequest, for: "5900525674bff71530823f5d") { (sub) in
            defer { expect.fulfill() }
            do {
                let sub = try sub()
                debugPrint(sub)
            } catch let error {
                debugPrint(error)
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 1000, handler: nil)
    }
    

    
    
    
}
