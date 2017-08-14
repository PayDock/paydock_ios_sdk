//
//  ExternalCheckout.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 13.08.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// External Checkout model
public struct ExternalCheckout: Parameterable, Mapable {
    
    public typealias Kind = ExternalCheckout
    
    /// Checkout type
    public var checkoutType: String?
    /// Checkout link
    public var link: String?
    /// Billing agreement reference value for Paypal checkout
    public var referenceId: String?
    /// Eternal checkout token to consume with One-time token creation
    public var token: String?
    
    /// Environment mode: test or live, optional
    public var mode: String? = "test" // request
    /// Payment gateway Id
    public var gatewayId: String? // request required
    /// Url to redirect when checkout succeed
    public var successRedirectUrl: String? // request required
    /// Url to redirect when checkout failed
    public var errorRedirectUrl: String? // request required
    /// Custom description that will be shown on a PayPal page when accepting the token
    public var description: String? // request
    
    
    /// JSON response
    public var rawJson: [String: Any]?
    
    init(json: Dictionary<String, Any>) throws {
        
        self.checkoutType = try? json.value(for: "checkout_type")
        self.link = try? json.value(for: "link")
        self.referenceId = try? json.value(for: "reference_id")
        self.mode = try? json.value(for: "mode")
        self.token = try? json.value(for: "token")
        self.rawJson = json
    }
    
    init(mode: String?, gatewayId: String?, successRedirectUrl: String?, errorRedirectUrl: String?, description: String?) {
        self.mode = mode
        self.gatewayId = gatewayId
        self.successRedirectUrl = successRedirectUrl
        self.errorRedirectUrl = errorRedirectUrl
        self.description = description
    }
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = [:]
        param.appendNonNilable(key: "mode", item: mode)
        param.appendNonNilable(key: "gateway_id", item: gatewayId)
        param.appendNonNilable(key: "success_redirect_url", item: successRedirectUrl)
        param.appendNonNilable(key: "error_redirect_url", item: errorRedirectUrl)
        param.appendNonNilable(key: "phone", item: description)
        return param
    }

}
