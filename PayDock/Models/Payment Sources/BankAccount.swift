//
//  BankAccount.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

public struct BankAccount: Parameterable, Mapable {
    public typealias Kind = BankAccount
    /// Bank Account ID
    public var id: String?
    /// Gateway ID
    public var gatewayId: String? // request required
    /// Customer account name. Parameter required when using Direct Debit only
    public var accountName: String?
    /// Number of Customer account. Parameter required when using Direct Debit only
    public var accountNumber: String? // request required
    /// Customer's Address
    public var address: Address?
    /// Number of Customer account. BSB/Routing/SWIFT/IBAN Number.
    public var accountRouting: String? // request required
    /// Type
    public var type: String?
    /// account type ('personal’ or 'business’)
    public var holderType: String? // request required
    /// Name of account bank
    public var bankName: String? // request required
    /// Updated Date
    public var updatedAt: Date?
    /// Created Date
    public var createdAt: Date?
    /// status
    public var status: String?
    /// ref token
    public var refToken: String?
    /// JSON response from server
    public var rawJson: [String: Any]?
    
    init(json: Dictionary<String, Any>) throws {
        self.id = try? json.value(for: "_id")
        self.gatewayId = try? json.value(for: "gateway_id")
        self.accountName = try? json.value(for: "account_name")
        self.accountNumber = try? json.value(for: "account_number")
        self.accountRouting = try? json.value(for: "account_routing")
        self.type = try? json.value(for: "type")
        self.holderType = try? json.value(for: "account_holder_type")
        self.bankName = try? json.value(for: "account_bank_name")
        self.status = try? json.value(for: "status")
        self.refToken = try? json.value(for: "ref_token")
        self.createdAt = try? json.value(for: "created_at")
        self.updatedAt  = try? json.value(for: "updated_at")
        self.address = try? Address(json: json)
        self.rawJson = json
    }
    
    public init(gatewayId: String, accountNumber: String?, accountName: String?, bankName: String?, accountRouting: String?, holderType: String?, address: Address?, type: String?) {
        self.gatewayId = gatewayId
        self.accountNumber = accountNumber
        self.accountRouting = accountRouting
        self.holderType = holderType
        self.bankName = bankName
        self.address = address
        self.type = type
        self.accountName = accountName
    }
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = ["type": "bank_account"]
        address?.toDictionary().forEach({ param[$0] = $1 })
        param.appendNonNilable(key: "gateway_id", item: gatewayId)
        param.appendNonNilable(key: "account_name", item: accountName)
        param.appendNonNilable(key: "account_number", item: accountNumber)
        param.appendNonNilable(key: "account_routing", item: accountRouting)
        param.appendNonNilable(key: "account_holder_type", item: holderType)
        param.appendNonNilable(key: "account_bank_name", item: bankName)
        param.appendNonNilable(key: "account_type", item: type)
        return param
    }
    
}
