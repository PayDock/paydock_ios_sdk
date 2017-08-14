//
//  ExternalCheckoutRequest.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 13.08.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// Parameter for External Checkout APIs
public struct ExternalCheckoutRequest : Parameterable {
    private var _externalCheckout: ExternalCheckout!
    
    /// Environment mode: test or live, optional
    public var mode: String? {
        get { return _externalCheckout.mode }
    }
    
    /// Payment gateway Id
    public var gatewayId: String {
        get { return _externalCheckout.gatewayId! }
    }
    
    /// Url to redirect when checkout succeed
    public var successRedirectUrl: String {
        get { return _externalCheckout.successRedirectUrl! }
    }
    
    /// Url to redirect when checkout failed
    public var errorRedirectUrl: String {
        get { return _externalCheckout.errorRedirectUrl! }
    }
    
    /// Custom description that will be shown on a PayPal page when accepting the token
    public var description: String? {
        get { return _externalCheckout.description }
    }
   
    /// init for checkout request
    public init(mode: String?, gatewayId: String?, successRedirectUrl: String?, errorRedirectUrl: String?, description: String? ) {
        _externalCheckout = ExternalCheckout(mode: mode, gatewayId: gatewayId, successRedirectUrl: successRedirectUrl, errorRedirectUrl: errorRedirectUrl, description: description)
    }
    
    
    public func toDictionary() -> [String : Any] {
        return _externalCheckout.toDictionary()
    }
}
