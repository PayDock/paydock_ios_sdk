//
//  CustomerServices.swift
//  PayDock
//
//  Created by Round Table Apps on 22/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Customer Services
class CustomerServices {
    weak var network: PayDockNetwork?
    
    init(network: PayDockNetwork) {
        self.network = network
    }

    /// add a customer with defualt payment source
    ///
    /// - parameter customer: customer request instance
    /// - parameter completion: returns a clouser which returns customer or throws error
    /// - paramter customer: customer item from sever
    func add(customer: CustomerRequest, completion: @escaping (_ result: @escaping () throws -> Customer) -> Void ) {
        network?.post(to: Constants.customers , with: customer.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let customer: Customer = try Customer(json: json)
                completion { return customer }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// get details for a customer
    ///
    /// - parameter with: customer's id
    /// - parameter completion: returns a clouser which returns customer or throws error
    /// - paramter customer: customer item from sever
    func getCustomer(with id: String, completion: @escaping (_ result: @escaping () throws -> Customer) -> Void) {
          let param: [String: Any] = [ "_id" : id]
        network?.get(from: Constants.customers, with: param, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let customer: Customer = try Customer(json: json)
                completion { return customer }
            } catch let error {
                completion { throw error }
            }
        })
    }
  
    /// get list of customers from server
    ///
    /// - parameter with: filter properties
    /// - parameter completion: returns a clouser which returns customers or throws error
    /// - paramter customer: customers item from sever
    func getCustomers(with parameters: ListParameters?, completion: @escaping (_ charges: @escaping () throws -> [Customer]) -> Void) {
        network?.get(from: Constants.customers, with: parameters?.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                var customers: [Customer] = []
                let json: [Dictionary<String, Any>] = try data.getResource()
                for object in json {
                    customers.append( try Customer(json: object))
                }
                completion {return customers }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// updates the customer's detail
    ///
    /// - parameter with: customer id
    /// - parameter customer: customer request instance
    /// - parameter completion: returns a clouser which returns customer or throws error
    /// - paramter customer: customer item from sever
    func updateCustomer(with id: String, customer: CustomerRequest, completion: @escaping (_ subscription: @escaping () throws -> Customer) -> Void) {
        let url = Constants.customers + "/" + id
        network?.put(to: url, with: customer.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let customer: Customer = try Customer(json: json)
                completion { return customer }
            } catch let error {
                completion { throw error }
            }
        })
    }

    /// archive a customer
    ///
    /// - parameter with: customer id
    /// - parameter completion: returns a clouser which returns customer or throws error
    /// - paramter customer: customer item from sever
    func archiveCustomer(with id: String, completion: @escaping (_ result: @escaping () throws -> Customer) -> Void) {
        let param: [String: Any] = [ "_id" : id]
        network?.delete(from: Constants.customers, with: param, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let customer: Customer = try Customer(json: json)
                completion { return customer }
            } catch let error {
                completion { throw error }
            }
        })
    }
}
