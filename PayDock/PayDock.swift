//
//  PayDock.swift
//  PayDock
//
//  Created by RTA on 10/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation
/// PayDock is an open-source SDK for iOS and a solution for collecting and handling payment sources in secure way through PayDock.
public class PayDock {
    
    public static var shared: PayDock = PayDock()
    fileprivate var chargeServices: ChargeServices!
    fileprivate var customerServices: CustomerServices!
    fileprivate var subscriptionServices: SubscriptionServices!
    fileprivate var tokenServices: TokenServices!
    fileprivate var externalCheckoutServices: ExternalCheckoutServices!
    
    /// paydock network protocol for handling requests
    var network: PayDockNetwork
    /// class variable for secret key
    static var _secretKey: String!
    /// instance variable for secret key
    public var secretKey: String
    /// class variable for public key
    static var _publicKey: String!
    /// instance variable for public key
    public var publicKey: String
    /// framework is used for sandbox or prodocution. it will change the base url. default is false.
    public var isSandbox: Bool = false {
        didSet {
            self.network.url = self.url
        }
    }
    /// returns paydock base url
    final var url: String {
        get {
            if let infoPlist = Bundle.init(identifier: "com.roundtableapps.PayDock")?.infoDictionary, let urls = infoPlist["urls"] as? [String: Any] {
                if isSandbox {
                    return urls["sandbox"] as? String ?? ""
                }
                return urls["production"] as? String ?? ""
            }
            return ""
        }
    }
    
    /// init PayDock class with a custom PayDockNetwork
    ///
    /// - parameter network: Custom Network Class for PayDock to use
    public init(network: PayDockNetwork) {
        self.network = network
        self.secretKey = PayDock._secretKey
        self.publicKey = PayDock._publicKey
        self.network.headerDictionary = [
            "content-type" : "application/json",
            "x-user-secret-key" : "\(self.secretKey)"
        ]
        self.network.url = self.url
        self.chargeServices = ChargeServices(network: self.network)
        self.subscriptionServices = SubscriptionServices(network: self.network)
        self.customerServices = CustomerServices(network: self.network)
        self.externalCheckoutServices = ExternalCheckoutServices(network: self.network)
        self.tokenServices = TokenServices(network: self.network, publicKey: publicKey)
    }
    /// create a paydock class with default network class
    private init() {
        self.secretKey = PayDock._secretKey
        self.publicKey = PayDock._publicKey
        self.network = PayDockSession()
        self.network.url = self.url
        self.chargeServices = ChargeServices(network: self.network)
        self.subscriptionServices = SubscriptionServices(network: self.network)
        self.customerServices = CustomerServices(network: self.network, publicKey: publicKey)
        self.externalCheckoutServices = ExternalCheckoutServices(network: self.network)
        self.tokenServices = TokenServices(network: self.network, publicKey: publicKey)
        self.network.headerDictionary = [
            "content-type" : "application/json",
            "x-user-secret-key" : "\(self.secretKey)"
            ]
        
    }
    /// set secret key for all instance of the PayDock
    ///
    /// - parameter key: secrete key from paydock
    public static func setSecretKey(key: String) {
        _secretKey = key
    }
    /// set public key for all instance of the PayDock
    ///
    /// - parameter key: public key from paydock
    public static func setPublicKey(key: String) {
        _publicKey = key
    }
}

// MARK:- Charge Services
public extension PayDock {
    /// Create Charge request. ChargeRequest init will define which type of add-charge request is created. see ChargeRequest inits for more information.
    ///
    /// - parameter charge: ChargeRequest for charging
    /// - parameter completion: result on creating charge
    /// - parameter chargeResponse: a throwable closure which returns an instance of a charge filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.add(charge: ChargeRequest) { (chargeResponse) in
    ///            do {
    ///                let createdCharge = try chargeResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func add(charge: ChargeRequest, completion: @escaping (_
        chargeResponse: @escaping () throws -> Charge) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.chargeServices.charge(with: charge) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Get specific charge detail
    ///
    /// - parameter with: Charge identifier
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - parameter chargeResponse: a throwable closure which returns an instance of a charge filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getCharge(with: {{id}}) { (chargeResponse) in
    ///            do {
    ///                let charge = try chargeResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func getCharge(with id: String, completion: @escaping (_ chargeResponse: @escaping () throws -> Charge) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.chargeServices.getCharge(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Get list of charges with parameter options. nil parameters will returns all charges for the account, limited to 100 records.
    ///
    /// - parameter with: optional parameters for filtering result
    /// - parameter completion: returns a closure which returns charges or throws error
    /// - parameter chargesResponse: a throwable closure which returns an array instance of charges filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getCharges(with: ListParameters) { (chargesResponse) in
    ///            do {
    ///                let chargeList = try chargesResponse()
    ///
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func getCharges(with parameters: ListParameters?, completion: @escaping (_ chargesResponse: @escaping () throws -> [Charge]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.chargeServices.getCharges(with: parameters) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// request to refund a charge
    ///
    /// - parameter with: Charge identifier
    /// - parameter amount: amount of money to refund
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - parameter chargeResponse: a throwable closure which returns an instance of a charge filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.refundCharge(with: {{id}}, amount: Float) { (chargeResponse) in
    ///            do {
    ///                let refundedCharge = try chargeResponse()
    ///            } catch let error {
    ///                print(error)
    ///            }
    ///        }
    ///```
    public func refundCharge(with id: String, amount: Float, completion: @escaping (_ chargeResponse: @escaping () throws -> Charge) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.chargeServices.refundCharge(with: id, amount: amount) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Archive Charge to hide it it from charges list. You can still retrieve archived charges, see [Get charges list with parameters
    ///
    /// - parameter with: Charge identifier
    /// - parameter completion: returns a closure which returns charge or throws error
    /// - parameter chargeResponse: a throwable closure which returns an instance of a charge filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.archiveCharge(with: {{id}}) { (chargeResponse) in
    ///            do {
    ///                let archivedCharge = try chargeResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func archiveCharge(with id: String, completion: @escaping (_ chargeResponse: @escaping () throws -> Charge) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.chargeServices.archiveCharge(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

// MARK:- Customer Services
public extension PayDock {
    /// add a customer with defualt payment source
    ///
    /// - parameter customer: customer request instance
    /// - parameter completion: returns a closure which returns customer or throws error
    /// - parameter customerResponse: a throwable closure which returns an instance of a Customer filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.add(customer: CustomerRequest) { (customerResponse) in
    ///            do {
    ///                let addedCustomer = try customerResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func add(customer: CustomerRequest, completion: @escaping (_ customerResponse: @escaping () throws -> Customer) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.add(customer: customer) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    /// get details for a customer
    ///
    /// - parameter with: customer's id
    /// - parameter completion: returns a closure which returns customer or throws error
    /// - parameter customerResponse: a throwable closure which returns an instance of a Customer filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getCustomer(with: {{id}}) { (customerResponse) in
    ///            do {
    ///                let customer = try customerResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func getCustomer(with id: String, completion: @escaping (_ customerResponse: @escaping () throws -> Customer) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.getCustomer(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// get list of customers from server
    ///
    /// - parameter with: filter properties
    /// - parameter completion: returns a closure which returns customers or throws error
    /// - parameter customersResponse: a throwable closure which returns an array instance of Customers filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getCustomers(with: ListParameters) { (customersResponse) in
    ///            do {
    ///                let customerList = try customersResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func getCustomers(with parameters: ListParameters?, completion: @escaping (_ customersResponse: @escaping () throws -> [Customer]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.getCustomers(with: parameters) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// get list of payment sources for cutomer from server
    ///
    /// - parameter with: filter properties
    /// - parameter completion: returns a closure which returns payment sources or throws error
    /// - parameter customersPaymentSourcesResponse: a throwable closure which returns an array instance of PaymentSource filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getCustomerPaymentSources(with: ListParameters) { (customersPaymentSourcesResponse) in
    ///            do {
    ///                let paymentSourceList = try customersPaymentSourcesResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func getCustomerPaymentSources(with parameters: ListParameters?, completion: @escaping (_ customersResponse: @escaping () throws -> [PaymentSource]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.getCustomerPaymentSources(with: parameters) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// updates the customer's detail
    ///
    /// - parameter customer: customer request instance
    /// - parameter for: customer id
    /// - parameter completion: returns a closure which returns customer or throws error
    /// - parameter customerResponse: a throwable closure which returns an instance of a Customer filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.update(customer: CustomerRequest, for: {{id}}) { (customerResponse) in
    ///            do {
    ///                let updatedCustomer = try customerResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func update(customer: CustomerRequest, for id: String, completion: @escaping (_ customerResponse: @escaping () throws -> Customer) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.updateCustomer(with: id, customer: customer) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// archive a customer
    ///
    /// - parameter with: customer id
    /// - parameter completion: returns a closure which returns customer or throws error
    /// - parameter customer: a throwable closure which returns an instance of a Customer filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.archiveCustomer(with: {{id}}) { (chargeResponse) in
    ///            do {
    ///                let archivedCharge = try chargeResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func archiveCustomer(with id: String, completion: @escaping (_ customerResponse: @escaping () throws -> Customer) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.customerServices.archiveCustomer(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

// MARK:- Subscription Services
public extension PayDock {
    
    /// Subscriptions are recurring billing events. These can be set up to take scheduled payments from a customer without having to re-enter the billing details.
    ///
    /// - Parameters:
    ///   - subscription: SubscriptionRequest object
    ///   - completion: result on creating Subscription
    ///   - subscriptionResponse: a throwable closure which returns an instance of a Subscription filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.add(subscription: SubscriptionRequest) { (subscriptionResponse) in
    ///            do {
    ///                let createdSubscription = try subscriptionResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func add(subscription: SubscriptionRequest, completion: @escaping (_ subscriptionResponse: @escaping () throws -> Subscription) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.subscriptionServices.create(subscription: subscription) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Retrieves data on subscription with specified ID.
    ///
    /// - Parameters:
    ///   - with: subscription identifier
    ///   - completion: result on getting a specified Subscription
    ///   - subscriptionResponse: a throwable closure which returns an instance of a Subscription filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getSubscription(with: {{id}}) { (subscriptionResponse) in
    ///            do {
    ///                let subscription = try subscriptionResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func getSubscription(with id: String, completion: @escaping (_ subscriptionResponse: @escaping () throws -> Subscription) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.subscriptionServices.getSubscription(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Returns all subscriptions for the account, limited to 100 records Or retrieving data on existing subscriptions can be driven by number of action parameters set in URI path.
    ///
    /// - Parameters:
    ///   - parameters: ListParameters Object to get list of subscriptions
    ///   - completion: result on getting list of Subscription
    ///   - subscriptionsResponse: a throwable closure which returns an array instance of Subscriptions filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.getsubscriptions(with: ListParameters) { (subscriptionsResponse) in
    ///            do {
    ///                let subscriptinList = try subscriptionsResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func getsubscriptions(with parameters: ListParameters?, completion: @escaping (_ subscriptionsResponse: @escaping () throws -> [Subscription]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.subscriptionServices.getSubscriptions(with: parameters) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Updates an existing subscription to adjust payment schedule or end conditions.
    ///
    /// - Parameters:
    ///   - subscription: SubscriptionRequest object
    ///   - for: subsctiprion identifier
    ///   - completion: result on updateing Subscription
    ///   - subscriptionResponse: a throwable closure which returns an instance of a Subscription filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.update(subscription: SubscriptionRequest, for: {{id}}) { (subscriptionResponse) in
    ///            do {
    ///                let updatedSubscription = try subscriptionResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func update(subscription: SubscriptionRequest, for id: String, completion: @escaping (_ subscriptionResponse: @escaping () throws -> Subscription) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.subscriptionServices.update(subscription: subscription, with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    /// Removes a subscription with specified ID.
    ///
    /// - Parameters:
    ///   - with: Subscription identifier
    ///   - completion: result on deleting Subscription
    ///   - subscriptionResponse: a throwable closure which returns an instance of a Subscription filled with server returned inforamation
    ///
    ///```
    ///        PayDock.shared.deleteSubscription(with: {{id}}) { (subscriptionResponse) in
    ///            do {
    ///                let deletedSubscription = try subscriptionResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    func deleteSubscription(with id: String, completion: @escaping (_ subscriptionResponse: @escaping () throws -> Subscription) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.subscriptionServices.deleteSubscription(with: id) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

// MARK:- Token Services

extension PayDock {
    /// Create One-time token request. It is a disposable token for creating charges/subscriptions/customers or updating customers.
    ///
    /// - parameter token: TokenRequest which is including customer details and paymentSource details
    /// - parameter completion: Result on creating token
    /// - parameter result: a throwable closure which returns a one-time token from server
    ///
    ///```
    ///        PayDock.shared.create(token: TokenRequest) { (tokenResponse) in
    ///            do {
    ///                let tokenString = try tokenResponse()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func create(token: TokenRequest, completion: @escaping (_ result: @escaping () throws -> String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.tokenServices.create(token: token){ (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

// MARK:- External Checkout Services

extension PayDock {
    
    
    /// Create a checkout url object
    ///
    /// - parameter customer: External checkout request instance
    /// - parameter completion: Result on creating external checkout
    /// - parameter customer: a throwable closure which returns a checkout item from server
    ///```
    ///        PayDock.shared.create(externalCheckout: ExternalCheckoutRequest) { (externalCheckoutResponce) in
    ///            do {
    ///                let checkout = try externalCheckoutResponce()
    ///            } catch let error {
    ///                print(error.localizedDescription)
    ///            }
    ///        }
    ///```
    public func create(externalCheckout: ExternalCheckoutRequest, completion: @escaping (_ result: @escaping () throws -> ExternalCheckout) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.externalCheckoutServices.create(externalCheckout: externalCheckout){ (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}


// MARK:- extensions
extension Collection where Iterator.Element == (key: String, value: Any) {
    internal mutating func appendNonNilable(key: String, item: Optional<Any>) {
        guard var selfJson = self as? Dictionary<String, Any> else {
            return
        }
        switch item {
        case .some(let wrapped):
            selfJson[key] = wrapped
        default:
            break
        }
        self = selfJson as! Self
    }
    func valueMapable<T: Mapable>(for key: String) throws -> T {
        guard let selfJson = self as? Dictionary<String, Any>, let json =  selfJson[key] as? Dictionary<String, Any> else {
            throw Errors.parsingFailed
        }
        return try T(json: json)
    }
    
    func value<T>(for key: String) throws -> T {
        guard var selfJson = self as? Dictionary<String, Any> else {
            throw Errors.parsingFailed
        }
        if type(of: T.self) == type(of: Date.self) {
            guard let stringValue = selfJson[key] as? String else {
                throw Errors.parsingFailed
            }
            guard let value = stringValue.toUTCDate() else {
                throw Errors.parsingFailed
            }
            return value as! T
        }
        guard let value = selfJson[key] as? T else {
            throw Errors.parsingFailed
        }
        return value
    }
}

internal extension Date {
    func toUTCString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.string(from: self)
    }
}

internal extension String {
    func toUTCDate() -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.date(from: self)
    }
    
    
}

extension Data {
    func getResource<T>() throws -> T {
        guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? Dictionary<String, Any> else {
            throw Errors.invalidJsonFormat
        }
        if let errorObject = json["error"] as? Dictionary<String,Any>,  let errorMessage: String = try? errorObject.value(for: "message") {
            throw Errors.serverError(message: errorMessage, details: errorObject as AnyObject, status: (json["status"] as! Int))
        }
        if let errorObject = json["error"] as? Dictionary<String,Any>,
            let errorComplexMessage: Any = try? errorObject.value(for: "message"),
            let errorMessage: String = try? (errorComplexMessage as! Dictionary).value(for: "message") {
            throw Errors.serverError(message: errorMessage, details: errorObject as AnyObject, status: (json["status"] as! Int))
        }
        if let resourceObject = json["resource"] as? Dictionary<String, Any>, let dataObject: T = try? resourceObject.value(for: "data") {
            return dataObject
        }
        throw Errors.invalidJsonFormat
    }
    
}
