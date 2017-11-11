//
//  Customer.swift
//  PayDock
//
//  Created by RTA on 18/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// customer model
public struct Customer: Parameterable, Mapable {
    
    public typealias Kind = Customer
    /// Customer ID
    public var id: String?
    /// Customer first name optional for one-time token
    public var firstName: String? // request
    /// Customer last name optional for one-time token
    public var lastName: String? // request
    /// Customer email optional for one-time token
    public var email: String? // request
    /// Manually defined reference for customer in payment systems
    public var reference: String? // request
    /// Customer phone in E.164 international notation (Example: +12345678901)
    public var phone: String? // request
    /// status
    public var status: String?
    /// default Payment Source ID
    public var defaultSource: String?
    ///
    public var _v: Int?
    /// Gateway ID
    public var gatewayId: String?
    /// One-time token with all the payment source information
    public var token: String?
    /// Created At Date
    public var createdAt: Date?
    /// Updated At Date
    public var updateAt: Date?
    /// list of Payment Sources
    public var paymentSources: [PaymentSource]?
    /// Payment Source
    public var paymentSource: PaymentSource? // request required for charge
    ///
    public var statistics: [String: Any]?
    ///
    public var _service: [String: Any]?
    /// JSON response
    public var rawJson: [String: Any]?
    
    init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, paymentSource: PaymentSource?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.reference = reference
        self.phone = phone
        self.paymentSource = paymentSource
    }
    
    init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.reference = reference
        self.phone = phone
    }
    
    init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, token: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.reference = reference
        self.phone = phone
        self.token = token
    }
    
    init(json: Dictionary<String, Any>) throws {

        self.firstName = try? json.value(for: "first_name")
        self.lastName = try? json.value(for: "last_name")
        self.id = try? json.value(for: "_id")
        self.email = try? json.value(for: "email")
        self.reference = try? json.value(for: "reference")
        self.phone = try? json.value(for: "phone")
        self.status = try? json.value(for: "status")
        self.defaultSource = try? json.value(for: "default_source")
        self._v = try? json.value(for: "__v")
        self.gatewayId = try? json.value(for: "gateway_id")
        self.token = try? json.value(for: "token")
        self.createdAt = try? json.value(for: "created_at")
        self.updateAt  = try? json.value(for: "updated_at")
        self.statistics = try? json.value(for: "statistics")
        self._service  = try? json.value(for: "__service")
        self.paymentSource = try? json.valueMapable(for: "payment_source")
        if let _paymentSources: [[String: Any]] = try? json.value(for: "payment_sources") {
            self.paymentSources = []
            for source in _paymentSources {
                if let _paymentSource: PaymentSource = try? PaymentSource(json: source) {
                    self.paymentSources?.append(_paymentSource)
                }
            }
        }
        self.rawJson = json
    }
    
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = [:]
        param.appendNonNilable(key: "first_name", item: firstName)
        param.appendNonNilable(key: "last_name", item: lastName)
        param.appendNonNilable(key: "email", item: email)
        param.appendNonNilable(key: "reference", item: reference)
        param.appendNonNilable(key: "phone", item: phone)
        param.appendNonNilable(key: "default_source", item: defaultSource)
        param.appendNonNilable(key: "token", item: token)
        param.appendNonNilable(key: "payment_source", item: paymentSource?.toDictionary())
        return param
    }
}
