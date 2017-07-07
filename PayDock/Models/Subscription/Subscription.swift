//
//  Subscription.swift
//  PayDock
//
//  Created by RTA on 4/19/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// subscription model
public struct Subscription: Parameterable, Mapable {
    public typealias Kind = Subscription
    /// Subscription ID
    var id: String?
    /// Amount of payment
    var amount: Float // request required
    /// Currency code, AUD by default
    var currency: String // request required
    /// Manually defined description for payments in payment systems
    var description: String? // request optional
    /// Manually defined reference for payments in payment systems
    var reference: String? // request optional
    /// One-time token with all payment source information
    var token: String? // request required
    /// Created At
    var createdAt: Date?
    /// Updated At
    var updatedAt: Date?
    /// status
    var status: String?
    /// is Archived
    var isArchived: Bool?
    /// ID of PayDock customer
    var customerId: String? // request required
    /// PaymentSource ID
    var paymentSourceId: String?
    /// Gateway Type
    var gatewayType: String?
    /// Gateway Name
    var gatewayName: String?
    /// Gateway Mode
    var gatewayMode: String?
    /// Company ID
    var companyId: String?
    /// User ID
    var userId: String?
    ///
    var _v: Int?
    /// JSON response
    var rawJson: [String: Any]?

    ///
    var service: [String: Any]?
    ///
    var statistics: [String: Any]?
    
    /// Customer with customers information
    var customer: Customer? // request required
    /// Schedule with subscription schedule information
    var schedule: Schedule? // request required
    
    private init(id: String?, amount: Float, currency: String, description: String?, reference: String?, token: String?, customerId: String?, schedule: Schedule?, customer: Customer?) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.description = description
        self.reference = reference
        self.token = token
        self.customerId = customerId
        self.schedule = schedule
        self.customer = customer
    }
    
    /// init for one-time token request
    init(amount: Float, currency: String, reference: String?, description: String?, token: String, schedule: Schedule ) {
        self.init(id: nil, amount: amount, currency: currency, description: description, reference: reference, token: token, customerId: nil, schedule: schedule, customer: nil)
    }
    
    /// init for Subscription with customer and payment source
    init(amount: Float, currency: String, reference: String?, description: String?, customer: Customer, schedule: Schedule) {
        self.init(id: nil, amount: amount, currency: currency, description: description, reference: reference, token: nil, customerId: nil, schedule: schedule, customer: customer)
    }
    
    /// init for Subscription with customer id
    init(amount: Float, currency: String, reference: String?, description: String?, customerId: String, schedule: Schedule ) {
        self.init(id: nil, amount: amount, currency: currency, description: description, reference: reference, token: nil, customerId: customerId, schedule: schedule, customer: nil)
    }
    
    /// init for updating subscription
     init(amount: Float, currency: String, reference: String?, description: String?, schedule: Schedule ) {
        self.init(id: nil, amount: amount, currency: currency, description: description, reference: reference, token: nil, customerId: nil, schedule: schedule, customer: nil)
    }
    
    init(json: Dictionary<String, Any>) throws {
        
        self.id = try? json.value(for: "_id")
        self.amount = try json.value(for: "amount")
        self.currency = try json.value(for: "currency")
        self.description = try? json.value(for: "description")
        self.reference = try? json.value(for: "reference")
        self.token = try? json.value(for: "token")
        self.createdAt = try? json.value(for: "created_at")
        self.updatedAt  = try? json.value(for: "updated_at")
        self.status = try? json.value(for: "status")
        self.isArchived = try? json.value(for: "archived")
        self.customerId = try? json.value(for: "customer_id")
        self.paymentSourceId = try? json.value(for: "payment_source_id")
        self._v = try? json.value(for: "__v")
        self.gatewayType = try? json.value(for: "gateway_type")
        self.gatewayName = try? json.value(for: "gateway_name")
        self.companyId = try? json.value(for: "company_id")
        self.userId = try? json.value(for: "user_id")
        self.customer = try? json.valueMapable(for: "customer")
        self.schedule = try? json.valueMapable(for: "schedule")
        
        self.rawJson = json
    }
    
    public func toDictionary() -> [String : Any] {
        
        var param: [String: Any] = [
            "amount": amount,
            "currency": currency ]
        param.appendNonNilable(key: "description", item: description)
        param.appendNonNilable(key: "reference", item: reference)
        param.appendNonNilable(key: "token", item: token)
        param.appendNonNilable(key: "customer_id", item: customerId)
        param.appendNonNilable(key: "payment_source_id", item: paymentSourceId)
        param.appendNonNilable(key: "gateway_type", item: gatewayType)
        param.appendNonNilable(key: "gateway_name", item: gatewayName)
        param.appendNonNilable(key: "gateway_mode", item: gatewayMode)
        param.appendNonNilable(key: "company_id", item: companyId)
        param.appendNonNilable(key: "user_id", item: userId)

        param.appendNonNilable(key: "customer", item: customer?.toDictionary())
        param.appendNonNilable(key: "schedule", item: schedule?.toDictionary())

        return param
    }
}
