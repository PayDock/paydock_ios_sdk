//
//  Refund.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


public struct Refund: Mapable {
    public typealias Kind = Refund
    
    init(json: Dictionary<String, Any>) throws {
        self.id = try json.value(for: "_id")
        self.amount = try json.value(for: "amount")
        self.currency = try json.value(for: "currency")
        self.status = try json.value(for: "status")
        self.pendedAt = try json.value(for: "pended_at")
        self.createdAt = try? json.value(for: "created_at")
        self.serviceLogs = try? json.value(for: "service_logs")
        self.rawJson = json
    }
    
    public var id: String
    public var amount: String
    public var currency: String
    public var status: String
    public var pendedAt: Date?
    public var createdAt: Date?
    public var serviceLogs: [[String: Any]]?
    public var rawJson: [String: Any]?
}
