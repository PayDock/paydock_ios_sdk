//
//  PayDockSession.swift
//  PayDock
//
//  Created by RTA on 15/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation
import UIKit

/// Default Network class for handling network requests
class PayDockSession {
    
    let configuration: URLSessionConfiguration!
    var payDockSession: URLSession!
    /// operation queue for URLSession delegateQueue
    let queue: OperationQueue
    fileprivate var _headerDictionary: [AnyHashable: Any]? {
        didSet {
            configuration.httpAdditionalHeaders = _headerDictionary
            payDockSession.invalidateAndCancel()
            payDockSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        }
    }
    fileprivate var _url: String!
    /// array of dataTask for handling duplicate requests
    var dataTasks: [String : URLSessionTask] = [:] {
        didSet {
            // show or hide network activity indicator
            if dataTasks.count != 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    init() {
        queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        queue.name = "paydockSession"
        configuration = URLSessionConfiguration.ephemeral
        configuration.httpAdditionalHeaders = self._headerDictionary
        payDockSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        configuration.allowsCellularAccess = true
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        configuration.networkServiceType = .default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    }
}

// MARK: PayDockNetwork Adoptation
extension PayDockSession: PayDockNetwork {
    
    var url: String {
        get {
            return _url
        }
        set {
            _url = newValue
        }
    }
    
    var headerDictionary: [AnyHashable : Any]? {
        get {
            return self._headerDictionary
        }
        set {
            self._headerDictionary = newValue
        }
    }
    /// validate URLSession response, data, error and throws an error when there is something wrong
    private func validateRespnose(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Data {
        guard error == nil else {
            throw error!
        }
        guard (response as? HTTPURLResponse) != nil else {
            throw Errors.networkError(reason: .noResponse)
        }
        guard let data = data else {
            throw Errors.networkError(reason: .unacceptableStatusCode)
        }
        return data
    }
    
    func get(from url: String, with parameters: [String : Any]?, completion: @escaping DataCompletion) {
        var url = self.url + url
        if let oldTask = self.dataTasks[url] {
            oldTask.cancel()
            dataTasks.removeValue(forKey: url)
        }
        guard let rawURL = URL(string: url ), let encodedURL = encodeParametersToUrl(url: rawURL, parameters: parameters)  else {
            completion({ throw Errors.urlInitFailed(reason: .couldNotCreateUrlWithGivenString) })
            return
        }
        let dataTask = payDockSession.dataTask(with: encodedURL) { (data, response, error) in
            defer {
                self.dataTasks.removeValue(forKey: url)
            }
            do {
                let data = try self.validateRespnose( data, response, error)
                completion { return data }
                
            } catch let error {
                completion { throw error }
            }
        }
        self.dataTasks[url] = dataTask
        dataTask.resume()
    }
    
    func post(to url: String, with parameters: [String : Any]?, completion: @escaping DataCompletion) {
        var url = self.url + url
        if let oldTask = self.dataTasks[url] {
            oldTask.cancel()
            dataTasks.removeValue(forKey: url)
        }
        guard let rawURL = URL(string: url ) else {
            completion({ throw Errors.urlInitFailed(reason: .couldNotCreateUrlWithGivenString) })
            return
        }
        var urlRequest = URLRequest(url: rawURL)
        urlRequest.httpMethod = "POST"
        
        if let parameters = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        let dataTask = payDockSession.dataTask(with: urlRequest) { (data, repsonse, error) in
            defer {
                self.dataTasks.removeValue(forKey: url)
            }
            do {
                let data = try self.validateRespnose(data, repsonse, error)
                completion { return data }
            } catch let error {
                completion { throw error}
            }
        }
        self.dataTasks[url] = dataTask
        dataTask.resume()
    }
    
    func put(to url: String, with parameters: [String : Any]?, completion: @escaping DataCompletion) {
        var url = self.url + url
        if let oldTask = self.dataTasks[url] {
            oldTask.cancel()
            dataTasks.removeValue(forKey: url)
        }
        guard let rawURL = URL(string: url ) else {
            completion({ throw Errors.urlInitFailed(reason: .couldNotCreateUrlWithGivenString) })
            return
        }
        var urlRequest = URLRequest(url: rawURL)
        urlRequest.httpMethod = "PUT"
        if let parameters = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        let dataTask = payDockSession.dataTask(with: urlRequest) { (data, repsonse, error) in
            defer {
                self.dataTasks.removeValue(forKey: url)
            }
            do {
                let data = try self.validateRespnose(data, repsonse, error)
                completion { return data }
            } catch let error {
                completion { throw error}
            }
        }
    }
    
    func delete(from url: String, with parameters: [String : Any]?, completion: @escaping DataCompletion) {
        var url = self.url + url
        if let oldTask = self.dataTasks[url] {
            oldTask.cancel()
            dataTasks.removeValue(forKey: url)
        }
        guard let rawURL = URL(string: url ), let encodedURL = encodeParametersToUrl(url: rawURL, parameters: parameters)  else {
            completion({ throw Errors.urlInitFailed(reason: .couldNotCreateUrlWithGivenString) })
            return
        }
        var urlRequest = URLRequest(url: encodedURL)
        urlRequest.httpMethod = "DELETE"

        let dataTask = payDockSession.dataTask(with: urlRequest) { (data, response, error) in
            defer {
                self.dataTasks.removeValue(forKey: url)
            }
            do {
                let data = try self.validateRespnose( data, response, error)
                completion { return data }
                
            } catch let error {
                completion { throw error }
            }
        }
        self.dataTasks[url] = dataTask
        dataTask.resume()
    }
}

//MARK:- Encoding Methods
extension PayDockSession {
    /// Encode parameters inside URL and return the encoded URL
    ///
    /// - parameter url: The url which parameters are going to be encode inside
    /// - parameter parameters: A Dictionary which is going to be ecoded as parameters
    ///
    /// - returns: a URL with encoded parameters inside
    func encodeParametersToUrl(url: URL, parameters: [String: Any]?) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        guard let parameters = parameters else { return urlComponents.url }
        let encodedQuery = (urlComponents.percentEncodedQuery.map({ $0 + "&" }) ?? "") + encode(parameters: parameters)
        urlComponents.percentEncodedQuery = encodedQuery
        return urlComponents.url
    }
    /// private method to create encoded paramteres string
    ///
    /// - parameter parameters: A Dictionary of Parameters
    ///
    /// - returns: Encoded paramterer URL String
    private func encode(parameters: [String: Any])  -> String {
        let items = parameters.map {  encode(key: $0, value: $1) }
        return items.joined(separator: "&")
    }
    
    /// recrusive function to go through keys and values and convert them to string
    ///
    /// - parameter key: Key in parameter dictionary
    /// - parameter value: Value in parameter dictionary
    ///
    /// - returns: Encoded String for the specefic key and value
    private func encode(key: String, value: Any) -> String {
        if let stringValue = value as? String {
            return "\(key.toPercent())=\(stringValue.toPercent())"
        } else if let boolValue = value as? Bool {
            return "\(key.toPercent())=\(String(boolValue ? 1 : 0).toPercent())"
        } else if let numberValue = value as? NSNumber {
            return "\(key.toPercent())=\(String(describing: numberValue).toPercent())"
        } else if let dictionaryValue = value as? [String: Any] {
            return dictionaryValue.map({
                encode(key: "\(key.toPercent())[\($0.toPercent())]", value: $1)
            }).joined(separator: "&")
        } else if let arrayValue = value as? [Any] {
            return arrayValue.map({ encode(key: "\(key.toPercent())[]", value: $0) }).joined(separator: "&")
        } else if let parameterableValue = value as? Parameterable {
            return parameterableValue.toDictionary().map({
                encode(key: "\(key.toPercent())[\($0.toPercent())]", value: $1)
            }).joined(separator: "&")
        }
        return ""
    }
}

// MARK: - private extensions
fileprivate extension String {
    /// Convert the string to percent encoded String
    ///
    /// - returns: percent encoded String
    func toPercent() -> String {
        let generalDelimiters = ":#[]@"
        let subDelimiters = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimiters)\(subDelimiters)")
        var percent = ""
        percent = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        return percent
    }
}

