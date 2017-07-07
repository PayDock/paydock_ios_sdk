//
//  Mapable.swift
//  PayDock
//
//  Created by RTA on 23/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Protocol that gives models ability to be mapped from json
protocol Mapable {
    
    associatedtype Kind
    
    /// init from json
    ///
    /// - Parameter json: Json Dictionary
    /// - Throws: errors if could not map from given JSON
    init(json: Dictionary<String, Any>) throws
    
}
