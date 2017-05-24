//
//  Schedule.swift
//  PayDock
//
//  Created by RTA on 4/19/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// schedule model
public struct Schedule: Parameterable, Mapable {
    
    public typealias Kind = Schedule
    
    /// Assessment interval one-off, week, month, year, day
    public var interval: String // request required
    /// Start date
    public var startDate: Date? // request optional
    /// End date
    public var endDate: Date? // request optional
    /// next assessent date
    public var nextAssessment: Date?
    /// first assessment date
    public var firstAssessment: Date?
    /// last assessment date
    public var lastAssessment: Date?
    /// status
    public var status: String?
    /// is Locked?
    public var isLocked: Bool?
    /// completed Payments
    public var completedCount: Bool?
    /// retry Count
    public var retryCount: Bool?
    /// Assessment frequency, 1 by default (i.e. “3” = “Every 3 weeks”)
    public var frequency: Int // request required
    /// Total amount of all successful transactions (equals or exceeds)
    public var endAmountAfter: Float?
    /// Total amount of all successful transactions (not to exceed)
    public var endAmountBefore: Float?
    /// Total count of all successful transactions
    public var endTransactions: Int?
    /// Total amount to be payid with subscription (equals). NOTE: If last payment of subscription schedule will be less then $ 1.00, some gateways may respond with error and subscription status will become 'failed’.
    public var endAmountTotal: Float?
    /// JSON response
    public var rawJson: [String: Any]?
    
    
    public init(interval: String, frequency: Int, startDate: Date?, endDate:Date?, endAmountAfter: Float?, endAmountBefore: Float?, endAmountTotal: Float?, endTransactions: Int?) {
        self.interval = interval
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.endAmountAfter = endAmountAfter
        self.endAmountBefore = endAmountBefore
        self.endAmountTotal = endAmountTotal
        self.endTransactions = endTransactions
    }
    
    init(json: Dictionary<String, Any>) throws {
        self.interval = try json.value(for: "interval")
        self.startDate = try? json.value(for: "startDate")
        self.frequency = try json.value(for: "frequency")
        self.endDate = try? json.value(for: "endDate")
        self.firstAssessment = try? json.value(for: "first_assessment")
        self.lastAssessment = try? json.value(for: "last_assessment")
        self.nextAssessment = try? json.value(for: "next_assessment")
        self.isLocked = try? json.value(for: "locked")
        self.status = try? json.value(for: "status")
        self.completedCount = try? json.value(for: "completed_count")
        self.retryCount = try? json.value(for: "retry_count")
        self.endAmountAfter = try? json.value(for: "end_amount_after")
        self.endAmountBefore = try? json.value(for: "end_amount_before")
        self.endAmountTotal = try? json.value(for: "end_amount_total")
        self.endTransactions = try? json.value(for: "end_transactions")
        self.rawJson = json
    }
    
    public func toDictionary() -> [String : Any] {
        var param: [String: Any] =  [
            "interval": interval,
            "frequency": self.frequency]
        param.appendNonNilable(key: "start_date", item: startDate?.toUTCString())
        param.appendNonNilable(key: "end_date", item: endDate?.toUTCString())
        param.appendNonNilable(key: "end_amount_after", item: endAmountAfter)
        param.appendNonNilable(key: "end_amount_before", item: endAmountBefore)
        param.appendNonNilable(key: "end_amount_total", item: endAmountTotal)
        param.appendNonNilable(key: "end_transactions", item: endTransactions)
        
        return param
    }
}
