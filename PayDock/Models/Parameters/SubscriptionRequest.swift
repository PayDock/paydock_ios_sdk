//
//  SubscriptionRequest.swift
//  PayDock
//
//  Created by RTA on 4/22/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Parameter for Subscription APIs
public struct SubscriptionRequest : Parameterable {
    private var _subscription: Subscription!
    
    /// Amount of payment
    public var amount: Float {
        get { return _subscription.amount }
    }
    
    /// Currency code, AUD by default
    public var currency: String {
        get { return _subscription.currency }
    }
    /// Manually defined reference for payments in payment systems
    public var reference: String? {
        get { return _subscription.reference }
    }
    /// Manually defined description for payments in payment systems
    public var description: String? {
        get { return _subscription.description }
    }
    /// One-time token with all payment source information
    public var token: String? {
        get { return _subscription.token }
    }
    /// Schedule with subscription schedule information
    public var schedule: Schedule {
        get { return _subscription.schedule! }
    }
    /// Customer with customers information
    public var customer: Customer? {
        get { return _subscription.customer }
        /// ID of PayDock customer
    }
    public var customerId: String? {
        get { return _subscription.customerId }
    }
    /// init for one-time token request
    public init(amount: Float, currency: String, reference: String?, description: String?, token: String, schedule: Schedule ) {
        _subscription = Subscription(amount: amount, currency: currency, reference: reference, description: description, token: token, schedule: schedule)
    }
    
    /// init for Subscription with customer and payment source
    public init(amount: Float, currency: String, reference: String?, description: String?, customer: CustomerRequest, schedule: Schedule) {
        _subscription = Subscription(amount: amount, currency: currency, reference: reference, description: description, customer: customer._customer, schedule: schedule)
    }
    
    /// init for Subscription with customer id
    public init(amount: Float, currency: String, reference: String?, description: String?, customerId: String, schedule: Schedule ) {
        _subscription = Subscription(amount: amount, currency: currency, reference: reference, description: description, customerId: customerId, schedule: schedule)
    }
    
    /// init for updating subscription
    public init(amount: Float, currency: String, reference: String?, description: String?, schedule: Schedule) {
        _subscription = Subscription(amount: amount, currency: currency, reference: reference, description: description, schedule: schedule)
    }
    
    public func toDictionary() -> [String : Any] {
        return _subscription.toDictionary()
    }
}
