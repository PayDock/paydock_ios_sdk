//
//  Constants.swift
//  PayDock
//
//  Created by RTA on 18/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// constant values
struct Constants {
    /// charge url
    static var charge = "v1/charges"
    
    /// subscriptino url
    static let subscription = "v1/subscriptions"
    
    /// token url
    static let token = "v1/payment_sources/tokens"
    
    /// customer url
    static let customers = "v1/customers"
    
    /// customer url
    static let paymentSources = "v1/customers/payment_sources"
    
    /// external checkout url
    static let externalCheckout = "v1/payment_sources/external_checkout"

    private init() { }
}
