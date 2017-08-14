//
//  PayDockNetwork.swift
//  PayDock
//
//  Created by RTA on 15/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

typealias DataCompletion = (_ data: () throws -> Data) -> Void

/// a protocol for implementing network requests for paydock API
public protocol PayDockNetwork: class {
    
    /// base url for paydock api
    var url: String { get set }
    /// needed headers for each request to paydock (content-type, x-user-secret-key)
    var headerDictionary: [AnyHashable : Any]? { get set }
    /// https request for GET methods
    ///
    /// - parameter from: url string
    /// - parameter with: parameters for request
    /// - parameter completion: a closure which returns a throwable closure which returns data
    ///
    /// - parameter data : Data from http response
    ///
    /// ```
    /// func get(from url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void) {
    ///     completion { return data }
    ///     //or
    ///     completion { throw error }
    /// }
    /// ```
    func get(from url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void)
    /// https request for POST methods
    ///
    /// - parameter from: url string
    /// - parameter with: parameters for request
    /// - parameter completion: a closure which returns a throwable closure which returns data
    ///
    /// - parameter data : Data from http response
    ///
    /// ```
    /// func post(to url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void) {
    ///     completion { return data }
    ///     //or
    ///     completion { throw error }
    /// }
    /// ```
    func post(to url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void)
    /// https request for PUT methods
    ///
    /// - parameter from: url string
    /// - parameter with: parameters for request
    /// - parameter completion: a closure which returns a throwable closure which returns data
    ///
    /// - parameter data : Data from http response
    ///
    /// ```
    /// func put(to url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void) {
    ///     completion { return data }
    ///     //or
    ///     completion { throw error }
    /// }
    /// ```
     func put(to url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void)
    /// https request for DELETE methods
    /// DELETE request should encode parameters inside url
    ///
    /// - parameter from: url string
    /// - parameter with: parameters for request
    /// - parameter completion: a closure which returns a throwable closure which returns data
    ///
    /// - parameter data : Data from http response
    ///
    /// ```
    /// func delete(from url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void) {
    ///     completion { return data }
    ///     //or
    ///     completion { throw error }
    /// }
    /// ```
    func delete(from url: String, with parameters: [String : Any]?, completion: @escaping (_ data: () throws -> Data) -> Void)
}


extension PayDockNetwork {
    var url: String {
        get {
            return PayDock.shared.url
        }
    }
    
    var headerDictionary: [AnyHashable : Any]? {
        get {
            return [
                "content-type" : "application/json",
                "x-user-secret-key" : "\(PayDock.shared.secretKey)"
            ]
        }
    }
}
