//
//  ChargeRequest.swift
//  PayDock
//
//  Created by RTA on 22/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation
/// Parameter for Charge APIs
public struct ChargeRequest: Parameterable {
    private let _charge: Charge
    
    /// Amount of payment
    public var amount: Float {
        get {
            return _charge.amount
        }
    }
    
    /// Currency code, AUD by default
    public var currency: String {
        get {
            return _charge.currency
        }
    }
    
    /// Customer
    public var customer: Customer? {
        get {
            return _charge.customer
        }
    }
    
    /// Existing customer ID
    public var customerId: String? {
        get {
            return _charge.customerId
        }
    }
    
    /// Payment source ID
    public var paymentSourceId: String? {
        get {
            return _charge.paymentSourceId
        }
    }
    
    
    /// One-time token with all the payment source information
    public var token: String? {
        get {
            return _charge.token
        }
    }
    
    /// Customer email
    public var email: String? {
        get {
            return _charge.email
        }
    }
    
    /// Manually defined description for payments in payment systems
    public var description: String? {
        get {
            return _charge.description
        }
    }
    
    
    /// Manually defined reference for customer in payment systems
    public var reference: String? {
        get {
            return _charge.reference
        }
    }
    
    /// init for Charge with credit card or bank Account
    public init(amount: Float, currency: String, reference: String?, description: String?, customer: CustomerRequest) {
        _charge = Charge(amount: amount, currency: currency, reference: reference, description: description, customer: customer._customer)
    }
    
    /// init for Charge with customer id
    public init(amount: Float, currency: String, reference: String?, description: String?, customerId: String) {
        _charge = Charge(amount: amount, currency: currency, reference: reference, description: description, customerId: customerId)
    }
    
    /// init for customer with non-default payment source
    public init(amount: Float, currency: String, reference: String?, description: String?, customerId: String, paymentSourceId: String) {
        _charge = Charge(amount: amount, currency: currency, reference: reference, description: description, customerId: customerId, paymentSourceId: paymentSourceId)
    }
    
    /// init for one-time token request
    public init(amount: Float, currency: String, token: String, reference: String?, description: String?, email: String?) {
        _charge = Charge(amount: amount, currency: currency, token: token, reference: reference, description: description, email: email)
    }
    
    public func toDictionary() -> [String : Any] {
        return _charge.toDictionary()
    }
}
