//
//  ExternalCheckoutServices.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 13.08.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// External Checkout Services
class ExternalCheckoutServices {
    weak var network: PayDockNetwork?
    
    init(network: PayDockNetwork) {
        self.network = network
    }
    
    /// create a checkout url object
    ///
    /// - parameter customer: external checkout request instance
    /// - parameter completion: returns a closure which returns checkout or throws error
    /// - parameter customer: checkout item from server
    func create(externalCheckout: ExternalCheckoutRequest, completion: @escaping (_ result: @escaping () throws -> ExternalCheckout) -> Void ) {
        self.network?.post(to: Constants.externalCheckout , with: externalCheckout.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let externalCheckout: ExternalCheckout = try ExternalCheckout(json: json)
                completion { return externalCheckout }
            } catch let error {
                completion { throw error }
            }
        })
    }
}
