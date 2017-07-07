//
//  Charge.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation
/// charge model
public struct Charge: Parameterable, Mapable {
    typealias Kind = Charge
    /// charge ID
    public var id: String?
    /// external ID
    public var externalId: String?
    /// subscription ID
    public var subscriptionId: String?
    /// company ID
    public var companyId: String?
    /// user ID
    public var userId: String?
    /// Amount of payment
    public var amount: Float
    /// Currency code, AUD by default
    public var currency: String = "AUD"
    /// Manually defined reference for customer in payment systems
    public var reference: String?
    /// Manually defined description for payments in payment systems
    public var description: String?
    /// One-time token with all the payment source information
    public var token: String?
    /// Customer email
    public var email: String?
    /// Existing customer ID
    public var customerId: String?
    /// Customer
    public var customer: Customer?
    /// Created Date
    public var createdAt: Date?
    /// Updated Date
    public var updatedAt: Date?
    /// is one off
    public var isOneOff: Bool?
    /// is archived
    public var isArchived: Bool?
    ///
    public var _v: Int?
    /// Payment source ID
    public var paymentSourceId: String?
    /// list of transactions
    public var transactions: [Transaction]?
    /// status
    public var status: String?
    /// JSON response
    public var rawJson: [String: Any]?
    
    
    private init(amount: Float, currency: String, reference: String?, description: String?, token: String?, email: String?, customerId: String?, customer: Customer?, paymentSourceId: String?) {
        self.amount = amount
        self.currency = currency
        self.reference = reference
        self.description = description
        self.token = token
        self.email = email
        self.customerId = customerId
        self.customer = customer
    }
    
    
    /// init for one-time token request
    init(amount: Float, currency: String, token: String, reference: String?, description: String?, email: String? ) {
        self.init(amount: amount, currency: currency, reference: reference, description: description, token: token, email: email, customerId: nil, customer: nil,paymentSourceId: nil)
    }
    
    /// init for Charge with credit card or bank Account
    init(amount: Float, currency: String, reference: String?, description: String?, customer: Customer) {
        self.init(amount: amount, currency: currency, reference: reference, description: description, token: nil, email: nil, customerId: nil, customer: customer, paymentSourceId: nil)
    }
    
    /// init for Charge with customer id
    init(amount: Float, currency: String, reference: String?, description: String?, customerId: String) {
        self.init(amount: amount, currency: currency, reference: reference, description: description, token: nil, email: nil, customerId: customerId, customer: nil, paymentSourceId: nil)
    }
    
    /// init for customer with non-default payment source
    init(amount: Float, currency: String, reference: String?, description: String?, customerId: String, paymentSourceId: String) {
        self.init(amount: amount, currency: currency, reference: reference, description: description, token: nil, email: nil, customerId: customerId, customer: nil, paymentSourceId: paymentSourceId)
    }
    init(json: Dictionary<String, Any>) throws {
        self.currency = try json.value(for: "currency")
        self.amount = try json.value(for: "amount")
        self.id = try? json.value(for: "_id")
        self.externalId = try? json.value(for: "external_id")
        self.subscriptionId = try? json.value(for: "subscription_id")
        self.companyId = try? json.value(for: "company_id")
        self.userId = try? json.value(for: "user_id")
        self.reference = try? json.value(for: "reference")
        self.description = try? json.value(for: "description")
        self.token = try? json.value(for: "token")
        self.email = try? json.value(for: "email")
        self.customerId = try? json.value(for: "customer_id")
        self.createdAt = try? json.value(for: "created_at")
        self.updatedAt  = try? json.value(for: "updated_at")
        self.isOneOff = try? json.value(for: "one_off")
        self.isArchived = try? json.value(for: "archived")
        self._v = try? json.value(for: "__v")
        self.paymentSourceId = try? json.value(for: "payment_source_id")
        self.status = try? json.value(for: "status")
        self.rawJson = json
        let transactions: [Dictionary<String,Any>]? = try? json.value(for: "transactions")
        if let availableTransactions = transactions {
            self.transactions = []
            for transaction in availableTransactions {
                if let maped:Transaction = try? Transaction(json: transaction) {
                    self.transactions?.append(maped)
                }
            }
        }
        
        if let _customer: Customer = try? json.valueMapable(for: "customer") {
            self.customer = _customer
        }
    }
    
    
   
    public func toDictionary() -> [String : Any] {
        var params: [String: Any] = [
            "amount": amount,
            "currency": currency]
        params.appendNonNilable(key: "reference", item: reference)
        params.appendNonNilable(key: "description", item: description)
        params.appendNonNilable(key: "token", item: token)
        params.appendNonNilable(key: "email", item: email)
        params.appendNonNilable(key: "customer_id", item: customerId)
        params.appendNonNilable(key: "payment_source_id", item: paymentSourceId)
        params.appendNonNilable(key: "customer", item: customer?.toDictionary())
        return params
    }
}




