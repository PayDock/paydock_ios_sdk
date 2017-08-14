//
//  ChargeServices.swift
//  PayDock
//
//  Created by RTA on 18/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Charge Services for SDK
class ChargeServices {
    weak var network: PayDockNetwork?
    
    init(network: PayDockNetwork) {
        self.network = network
    }
    
    /// Create Charge request. ChargeRequest init will define which type of add-charge request is created. see ChargeRequest inits for more information
    ///
    /// - parameter with: ChargeRequest for charging
    /// - parameter completion: result on creating charge
    /// - parameter charge: a charge instance filled with server response
    func charge(with charge: ChargeRequest, completion: @escaping (_ result: @escaping () throws -> Charge) -> Void) {
        self.network?.post(to: Constants.charge, with: charge.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let charge: Charge = try Charge(json: json)
                completion { return charge }
            } catch let error {
                completion { throw error }
            }
        })
    }

    /// Get list of charges with parameter options. nil parameters will returns all charges for the account, limited to 100 records.
    ///
    /// - parameter with: optional parameters for filtering result
    /// - parameter completion: returns a closure which returns charges or throws error
    /// - paramter charges: charge items from server
    func getCharges(with parameters: ListParameters?, completion: @escaping (_ charges: @escaping () throws -> [Charge]) -> Void) {
        self.network?.get(from: Constants.charge, with: parameters?.toDictionary(), completion: { (result) in
            do {
                let data = try result()
                var charges: [Charge] = []
                let json: [Dictionary<String, Any>] = try data.getResource()
                for object in json {
                    charges.append( try Charge(json: object))
                }
                completion {return charges }
            } catch let error {
                completion { throw error }
            }
        })
        
    
    }
    /// Get specific charge detail
    ///
    /// - parameter with: Charge identifier
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - paramter charge: charge item from server
    func getCharge(with id: String, completion: @escaping (_ charge: @escaping () throws -> Charge) -> Void) {
        let parameter: [String: Any] = ["_id" : id]
        self.network?.get(from: Constants.charge, with: parameter, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let charge: Charge = try Charge(json: json)
                completion { return charge }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// request to refund a charge
    ///
    /// - parameter with: Charge identifier
    /// - parameter amount: amount of money to refund
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - paramter charge: charge item from server
    func refundCharge(with id: String, amount: Float, completion: @escaping (_ charge: @escaping () throws -> Charge) -> Void) {
        let parameter: [String: Any] = ["_id" : id, "amount" : amount]
        self.network?.post(to: Constants.charge, with: parameter, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let charge: Charge = try Charge(json: json)
                completion { return charge }
            } catch let error {
                completion { throw error }
            }
        })
    }
    
    /// Archive Charge to hide it it from charges list. You can still retrieve archived charges, see [Get charges list with parameters
    ///
    /// - parameter with: Charge identifier
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - paramter charge: charge item from server
    func archiveCharge(with id: String, completion: @escaping (_ charge: @escaping () throws -> Charge) -> Void) {
        let url = Constants.charge + "/\(id)"
        self.network?.delete(from: url, with: nil, completion: { (result) in
            do {
                let data = try result()
                let json: [String: Any] = try data.getResource()
                let charge: Charge = try Charge(json: json)
                completion { return charge }
            } catch let error {
                completion { throw error }
            }
        })
    }
}
