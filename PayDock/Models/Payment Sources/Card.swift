//
//  Card.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

public struct Card: Parameterable, Mapable {
    typealias Kind = Card
    /// card id
    public var id: String?
    /// Cardholder name (as on card)
    public var name: String? // request required
    /// Card number
    public var number: String? // request required
    /// Last 4 digits of Card Number
    public var last4Number: String?
    /// Card CCV number
    public var ccv: String?
    /// Card Scheme
    public var scheme: String?
    /// Card expiration month mm format
    public var expireMonth: Int? // request required
    /// Card expiration year yyyy format
    public var expireYear: Int? // request required
    /// Customer's Address
    public var address: Address?
    /// Gateway ID
    public var gatewayId: String? // request required
    /// ref Token
    public var refToken: String?
    /// Created Date
    public var createdAt: Date?
    /// Updated Date
    public var updatedAt: Date?
    /// raw json response from server
    public var rawJson: [String: Any]?
    // primary
    public var primary :Bool?
    
    public init(gatewayId: String, name: String, number: String, expireMonth: Int, expireYear: Int, ccv: String?, address: Address?) {
        self.gatewayId = gatewayId
        self.name = name
        self.number = number
        self.expireMonth = expireMonth
        self.expireYear = expireYear
        self.address = address
        self.ccv = ccv
    }
    
    init(json: Dictionary<String, Any>) throws {
        self.primary = try? json.value(for: "primary")
        self.id = try? json.value(for: "_id")
        self.name = try? json.value(for: "card_name")
        self.number = try? json.value(for: "card_number")
        self.last4Number = try? json.value(for: "card_number_last4")
        self.ccv = try? json.value(for: "card_ccv")
        self.scheme = try? json.value(for: "card_scheme")
        self.expireMonth = try? json.value(for: "expire_month")
        self.expireYear = try? json.value(for: "expire_year")
        self.gatewayId = try? json.value(for: "gateway_id")
        self.refToken = try? json.value(for: "ref_token")
        self.createdAt = try? json.value(for: "created_at")
        self.updatedAt  = try? json.value(for: "updated_at")
        self.address = try? Address(json: json)
        self.rawJson = json
     
    }
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = ["type": "card"]
        address?.toDictionary().forEach { (key, value) in
            param[key] = value
        }
        param.appendNonNilable(key: "card_name", item: name)
        param.appendNonNilable(key: "expire_year", item: expireYear)
        param.appendNonNilable(key: "expire_month", item: expireMonth)
        param.appendNonNilable(key: "card_number", item: number)
        param.appendNonNilable(key: "card_ccv", item: ccv)
        param.appendNonNilable(key: "gateway_id", item: gatewayId)
        param.appendNonNilable(key: "card_scheme", item: scheme)
        param.appendNonNilable(key: "id", item: id)
        param.appendNonNilable(key: "card_number_last4", item: last4Number)
       // param.appendNonNilable(key: "rawJson", item: rawJson)
        param.appendNonNilable(key: "primary", item: primary)
        return param
    }
    
}
