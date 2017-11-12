//
//  BSB.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

public struct BSB: Parameterable,Mapable {
    public typealias Kind = BSB
    
    /// bsb ID
    public var id: String?
    /// Gateway ID
    public var gatewayId: String? // request required
    /// Gateway Name
    public var gatewayName: String?
    /// Gateway Type
    public var gatewayType: String?
    /// Gateway Mode
    public var gatewayMode: String?
    /// Number of Customer account. Parameter required when using Direct Debit only
    public var accountNumber: String? // request required
    /// Customer bank state branch number. Parameter required when using Direct Debit only
    public var accountBSB: String? // request required
    /// Customer account name. Parameter required when using Direct Debit only
    public var accountName: String? // request required
    /// Customer's Address
    public var address: Address?
    /// ref Token
    public var refToken: String?
    /// status
    public var status: String?
    /// Created Date
    public var createdAt: Date?
    /// Updated At
    public var updatedAt: Date?
    /// Raw Json Response from server
    public var rawJson: [String: Any]?
    // primary
    public var primary :Bool?
    init(json: Dictionary<String, Any>) throws {
        self.primary = try? json.value(for: "primary")
        self.id = try? json.value(for: "_id")
        self.gatewayId = try? json.value(for: "gateway_id")
        self.gatewayName = try? json.value(for: "gateway_name")
        self.gatewayType = try? json.value(for: "gateway_type")
        self.gatewayMode = try? json.value(for: "gateway_mode")
        self.accountNumber = try? json.value(for: "account_number")
        self.accountBSB = try? json.value(for: "account_bsb")
        self.accountName = try? json.value(for: "account_name")
        self.status = try? json.value(for: "status")
        self.refToken = try? json.value(for: "ref_token")
        self.createdAt = try? json.value(for: "created_at")
        self.updatedAt  = try? json.value(for: "updated_at")
        self.address = try? Address(json: json)
        self.rawJson = json
    }
    public init(gatewayId: String, accountNumber: String?, accountName: String?, accountBSB: String) {
        self.gatewayId = gatewayId
        self.accountNumber = accountNumber
        self.accountBSB = accountBSB
        self.accountName = accountName
    }
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = ["type": "bsb"]
        address?.toDictionary().forEach({ param[$0] = $1 })
        param.appendNonNilable(key: "id", item: self.id)
        param.appendNonNilable(key: "gateway_id", item: gatewayId)
        param.appendNonNilable(key: "gateway_name", item: gatewayName)
        param.appendNonNilable(key: "gateway_type", item: gatewayType)
        param.appendNonNilable(key: "gateway_mode", item: gatewayMode)
        param.appendNonNilable(key: "account_number", item: accountNumber)
        param.appendNonNilable(key: "account_bsb", item: accountBSB)
        param.appendNonNilable(key: "account_name", item: accountName)
        // param.appendNonNilable(key: "rawJson", item: rawJson)
         param.appendNonNilable(key: "primary", item: primary)
        return param
    }
    
}
