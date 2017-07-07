//
//  Sale.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


public struct Sale: Mapable {
    public typealias Kind = Sale
   
    init(json: Dictionary<String, Any>) throws {
        self.id = try json.value(for: "_id")
        self.amount = try json.value(for: "amount")
        self.currency = try json.value(for: "currency")
        self.status = try json.value(for: "status")
        self.createdAt = try? json.value(for: "created_at")
        self.serviceLogs = try? json.value(for: "service_logs")
        self.rawJson = json
    }
    public var id: String
    public var amount: Float
    public var currency: String
    public var status: String
    public var createdAt: Date?
    public var serviceLogs: [[String: Any]]?
    public var rawJson: [String: Any]?

}
