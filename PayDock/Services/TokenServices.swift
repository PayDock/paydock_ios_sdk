//
//  TokenServices.swift
//  PayDock
//
//  Created by RTA on 4/22/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// Token Services
class TokenServices {
    weak var network: PayDockNetwork?
    var publicKey: String
    
    init(network: PayDockNetwork, publicKey: String) {
        self.network = network
        self.publicKey = publicKey
    }
    
    /// Create One-time token request. It is a disposable token for creating charges/subscriptions/customers or updating customers.
    ///
    /// - parameter token: TokenRequest which is including customer details and paymentSource details
    /// - parameter completion: Result on creating token
    /// - parameter result: A token as a string
    public func create(token: TokenRequest, completion: @escaping (_ result: @escaping () throws -> String) -> Void) {
        let relativeUrl = Constants.token + "?public_key=\(publicKey)"
        self.network?.post(to: relativeUrl, with: token.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let token: String = try data.getResource()
                completion { return token }
            } catch let error {
                completion { throw error }
            }
        })
    }
}
