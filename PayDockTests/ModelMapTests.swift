//
//  ModelMapTests.swift
//  PayDock
//
//  Created by RTA on 29/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import XCTest
@testable import PayDock
class ModelMapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK:- Loading JSON Files
    fileprivate lazy var chargeInfoJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "chargeInfo", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var chargeListJson: [Any] = {
        let path = Bundle(for: type(of: self)).path(forResource: "chargeList", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
    }()
    
    fileprivate lazy var chargeAddJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "chargeAdd", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    fileprivate lazy var customerInfoJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "customerItem", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var customerListJson: [Any] = {
        let path = Bundle(for: type(of: self)).path(forResource: "customerList", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
    }()
    
    fileprivate lazy var customerAddJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "customerAdd", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var subscriptionAddJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "subscriptionAdd", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var subscriptionUpdateJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "subscriptionUpdate", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var subscriptionListJson: [Any] = {
        let path = Bundle(for: type(of: self)).path(forResource: "subscriptionList", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
    }()
    
    fileprivate lazy var subscriptionItemJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "subscriptionItem", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
    fileprivate lazy var externalCheckoutAddJson: [String: Any] = {
        let path =  Bundle(for: type(of: self)).path(forResource: "externalCheckoutAdd", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }()
    
}

//MARK:- Charge Model Map
extension ModelMapTests {
    
    func testMappingChargeInfo() {
        _ = chargeInfoJson
        self.measure {
            let chargeInfo =  try? Charge(json: self.chargeInfoJson)
            XCTAssertNotNil(chargeInfo, "could not map chargeinfoJson")
        }
    }
    
    func testMappingChargeAdd() {
        _ = chargeAddJson
        self.measure {
            let addCharge =  try? Charge(json: self.chargeAddJson)
            XCTAssertNotNil(addCharge, "could not map addChargeJson")
        }
    }
    
    func testMappingChargeList() {
        _ = chargeListJson
        self.measure {
            var chargelist: [Charge] = []
            for chargeDictionary in self.chargeListJson {
                chargelist.append(try! Charge(json: chargeDictionary as! Dictionary<String, Any>))
                
            }
            XCTAssert(chargelist.count == 2, "didnt map properly")
        }
    }
}

//MARK:- Subscription Model Map
extension ModelMapTests {
    func testMappingSubscriptionAdd() {
        _ = subscriptionAddJson
        self.measure {
            let subscription = try? Subscription(json: self.subscriptionAddJson)
            XCTAssertNotNil(subscription, "could not convert subscrition for add subscription response")
        }
    }
    
    func testMappingSubscriptionUpdate() {
        _ = subscriptionUpdateJson
        self.measure {
            let subscription = try? Subscription(json: self.subscriptionUpdateJson)
            XCTAssertNotNil(subscription, "could not convert subscrition for update subscription response")
        }
    }
    
    func testMappingSubscriptionItem() {
        _ = subscriptionItemJson
        self.measure {
            let subscription = try? Subscription(json: self.subscriptionItemJson)
            XCTAssertNotNil(subscription, "could not convert subscrition for item subscription response")
        }
    }
    
    func testMappingSubscriptionList() {
        _ = subscriptionListJson
        self.measure {
            var subscriptions: [Subscription] = []
            for subscriptionJson in self.subscriptionListJson {
                if let subscription: Subscription = try? Subscription(json: subscriptionJson as! Dictionary<String, Any>) {
                    subscriptions.append(subscription)
                }
            }
            XCTAssert(subscriptions.count == 2,  "could not convert subscrition for list subscription response")
        }
    }
}

//MARK:- External Checkout Model Map
extension ModelMapTests {
    
    
    func testMappingExternalCheckoutAdd() {
        _ = externalCheckoutAddJson
        self.measure {
            let checkout =  try? ExternalCheckout(json: self.externalCheckoutAddJson)
            XCTAssertNotNil(checkout, "could not map externalCheckoutAddJson")
        }
    }
    
}

