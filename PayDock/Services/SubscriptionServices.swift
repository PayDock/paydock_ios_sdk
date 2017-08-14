//
//  SubscriptionService.swift
//  PayDock
//
//  Created by RTA on 4/19/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Subscription Services
class SubscriptionServices {
    weak var network: PayDockNetwork?
    
    init(network: PayDockNetwork) {
        self.network = network
    }
    
    /// Create Subscription request. Subscription init will define which type of add-subscription request is created. see subscription inits for more information
    ///
    /// - parameter subscription: one-time Token parameter model
    /// - parameter completion: result on creating subscription
    /// - parameter result: test
    func create(subscription: SubscriptionRequest, completion: @escaping (_ result: @escaping () throws -> Subscription) -> Void) {
        self.network?.post(to: Constants.subscription, with: subscription.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let subscription: Subscription = try Subscription(json: json)
                completion { return subscription }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// Update subscription details
    ///
    /// - parameter subscription: SubscriptionRequest parameter model
    /// - parameter with: subscription identifier
    /// - parameter completion: returns a closure which returns subscription or throws error
    /// - paramter subscription: subscription item from server
    func update(subscription: SubscriptionRequest, with id: String, completion: @escaping (_ subscription: @escaping () throws -> Subscription) -> Void) {
        let relativeUrl = Constants.subscription + "/\(id)"
        self.network?.post(to: relativeUrl, with: subscription.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let subscription: Subscription = try Subscription(json: json)
                completion { return subscription }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// Get list of subscriptions with parameter options. nil parameters will returns all subscriptions for the account, limited to 100 records.
    ///
    /// - parameter with: optional parameters for filtering result
    /// - parameter completion: returns a closure which returns subscription or throws error
    /// - paramter subscriptions: Subscription items from server
    func getSubscriptions(with parameters: ListParameters?, completion: @escaping (_ subscriptions: @escaping () throws -> [Subscription]) -> Void) {
        self.network?.get(from: Constants.subscription, with: parameters?.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                var subscriptions: [Subscription] = []
                let json: [Dictionary<String, Any>] = try data.getResource()
                for object in json {
                    subscriptions.append( try Subscription(json: object))
                }
                completion { return subscriptions }
            } catch let error {
                completion { throw error }
            }
        })
        
        
    }
    
    /// Get specific subscription detail
    ///
    /// - parameter with: Subscription identifier
    /// - parameter completion: returns a closure which returns subscription or throws error
    /// - paramter subscription: subscription item from server
    func getSubscription(with id: String, completion: @escaping (_ subscription: @escaping () throws -> Subscription) -> Void) {
        let parameter: [String: Any] = ["_id" : id]
        self.network?.get(from: Constants.subscription, with: parameter, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let subscription: Subscription = try Subscription(json: json)
                completion { return subscription }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// Delete specific subscription
    ///
    /// - parameter with: Subscription identifier
    /// - parameter completion: returns a closure which returns subscription or throws error
    /// - paramter subscription: subscription item from server
    func deleteSubscription(with id: String, completion: @escaping (_ subscription: @escaping () throws -> Subscription) -> Void) {
        let parameter: [String: Any] = ["_id" : id]
        self.network?.delete(from: Constants.subscription, with: parameter, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let subscription: Subscription = try Subscription(json: json)
                completion { return subscription }
            } catch let error {
                completion { throw error }
            }
        })
    }


}
