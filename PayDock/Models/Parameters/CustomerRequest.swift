//
//  CustomerRequest.swift
//  PayDock
//
//  Created by RTA on 22/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Parameter for Customer APIs
public struct CustomerRequest: Parameterable {
    let _customer: Customer
    
    /// Customer first name optional for one-time token
    public var firstName: String? {
        get {
            return _customer.firstName
        }
    }
    
    /// Customer last name optional for one-time token
    public var lastName: String? {
        get {
            return _customer.lastName
        }
    }
    
    /// Customer email optional for one-time token
    public var email: String? {
        get {
            return _customer.email
        }
    }
    
    
    /// Customer phone in E.164 international notation (Example: +12345678901)
    public var phone: String? {
        get {
            return _customer.phone
        }
    }
    
    /// Manually defined reference for customer in payment systems
    public var reference: String? {
        get {
            return _customer.reference
        }
    }
    
    /// One-time token with all the payment source information
    public var token: String? {
        get {
            return _customer.token
        }
    }
    
    /// Payment Source
    public var paymentSource: PaymentSource? {
        get {
            return _customer.paymentSource
        }
    }
    
    /// init CustomerRequest with Payment Source (credit card details, direct debit details using bank account or BSB)
    public init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, paymentSource: PaymentSource) {
        _customer = Customer(firstName: firstName, lastName: lastName, email: email, reference: reference, phone: phone, paymentSource: paymentSource)
    }
    /// init CustomerRequest without Payment Source
    public init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?) {
        _customer = Customer(firstName: firstName, lastName: lastName, email: email, reference: reference, phone: phone)
    }
    /// init CustomerRequest with one-time Token
    public init(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, token: String) {
        _customer = Customer(firstName: firstName, lastName: lastName, email: email, reference: reference, phone: phone, token: token)
    }
    
    public func toDictionary() -> [String : Any] {
        return _customer.toDictionary()
    }
}
