//
//  Address.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// address model
public struct Address: Parameterable, Mapable {
    public typealias Kind = Address
    
    
    /// Customer Address, line 1
    public var line1: String?
    /// Customer Address, line 2
    public var line2: String?
    /// Customer Address, City
    public var city: String?
    /// Customer Address, Postcade
    public var postcode: String?
    /// Customer Address, State
    public var state: String?
    /// Customer Address, Country Code
    public var country: String?
    
    init(json: Dictionary<String, Any>) throws {
        self.line1 = try? json.value(for: "address_line1")
       
        self.line2 = try? json.value(for: "address_line2")
        //self.line2 = try? json.value(for: "line2")
        //self.city = try? json.value(for: "city")
        self.city = try? json.value(for: "address_city")
//        self.postcode = try? json.value(for: "postcode")
        self.postcode = try? json.value(for: "address_postcode")
        self.state = try? json.value(for: "address_state")
       // self.state = try? json.value(for: "state")
//        self.country = try? json.value(for: "country")
        self.country = try? json.value(for: "address_country")
    }
    
    public init(line1: String?, line2: String?, city: String?, postcode: String?, state: String?, country: String?) {
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.postcode = postcode
        self.state = state
        self.country = country
    }
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = [:]
        param.appendNonNilable(key: "line1", item: line1)
        param.appendNonNilable(key: "line2", item: line2)
        param.appendNonNilable(key: "city", item: city)
        param.appendNonNilable(key: "state", item: state)
        param.appendNonNilable(key: "country", item: country)
        param.appendNonNilable(key: "postcode", item: postcode)
        return param
    }
}
