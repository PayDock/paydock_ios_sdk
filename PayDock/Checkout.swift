//
//  Card.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

public struct Checkout: Parameterable, Mapable {
    public typealias Kind = Checkout
    /// card id
    public var id: String?
    /// Cardholder name (as on card)
    public var status: String?
    /// Cardholder name (as on card)
    public var type: String?
    /// Cardholder name (as on card)
    public var checkoutEmail: String?
    /// Cardholder name (as on card)
    public var checkoutHolder: String?
    /// Cardholder name (as on card)
    public var address: Address?
    /// Gateway ID
    public var gatewayId: String?
    public var customerId: String?
    public var gatewayType: String?
    public var gatewayMode: String?
    public var customerReference: String?
    /// ref Token
    public var refToken: String?
    /// Created Date
    public var createdAt: Date?
    /// Updated Date
    public var updatedAt: Date?
    // primary
    public var primary :Bool?    
    public var rawJson: [String: Any]?

    
    init(json: Dictionary<String, Any>) throws {
        self.id = try? json.value(for: "_id")
        self.checkoutEmail = try? json.value(for: "checkout_email")
        self.checkoutHolder = try? json.value(for: "checkout_holder")
        self.type  = try? json.value(for: "type")
        // self.status = try? json.value(for: "status")
        self.gatewayId = try? json.value(for: "gateway_id")
        self.customerId = try? json.value(for: "customer_id")
        self.gatewayType = try? json.value(for: "gateway_type")
        self.gatewayMode = try? json.value(for: "gateway_mode")
        self.primary = try? json.value(for: "primary")
        self.customerReference = try? json.value(for: "customer_reference")
        
//        self.refToken = try? json.value(for: "ref_token")
//        self.createdAt = try? json.value(for: "created_at")
//        self.updatedAt  = try? json.value(for: "updated_at")
//        
//        self.address = try? Address(json: json)
//        self.rawJson = json
        
    }
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = ["type": "checkout"]
        address?.toDictionary().forEach { (key, value) in
            param[key] = value
        }
        param.appendNonNilable(key: "_id", item: id)
        param.appendNonNilable(key: "checkout_email", item: checkoutEmail)
        param.appendNonNilable(key: "checkout_holder", item: checkoutHolder)
        param.appendNonNilable(key: "type", item: type)
        param.appendNonNilable(key: "gateway_id", item: gatewayId)
        param.appendNonNilable(key: "customer_id", item: customerId)
        param.appendNonNilable(key: "gateway_type", item: gatewayType)
        param.appendNonNilable(key: "gateway_mode", item: gatewayMode)
        
        // param.appendNonNilable(key: "rawJson", item: rawJson)
        param.appendNonNilable(key: "primary", item: primary)
        param.appendNonNilable(key: "customer_reference", item: customerReference)
        return param
    }

    
}
