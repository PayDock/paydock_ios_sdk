//
//  Parameterable.swift
//  PayDock
//
//  Created by Round Table Apps on 18/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// protocol to turn objects to Dictionary<String,Any>
public protocol Parameterable {
    /// convert the class to Dictionary sutable for parameters
    func toDictionary() -> [String: Any]
}
