//
//  Token.swift
//  PayDock
//
//  Created by RTA on 4/22/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Parameters to get one-time token
public struct TokenRequest: Parameterable {
    
    /// CustomerRequest instance
    public var customer: CustomerRequest?
    /// Address instance
    public  var address: Address?
    /// Payment Source Instance
    public var paymentSource: PaymentSource
    
    public init(customer: CustomerRequest?, address: Address?, paymentSource: PaymentSource ) {
        self.customer = customer
        self.address = address
        self.paymentSource = paymentSource
    }
    
    public func toDictionary() -> [String : Any] {
        var param = [String: Any]()
        address?.toDictionary().forEach { (key, value) in
            param[key] = value
        }
        customer?.toDictionary().forEach { (key, value) in
            param[key] = value
        }   
        paymentSource.toDictionary().forEach { (key, value) in
            param[key] = value
        }
        return param
    }
}
