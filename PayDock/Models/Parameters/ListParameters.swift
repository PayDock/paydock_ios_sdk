//
//  ChargeListParameters.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation

/// Parameter for geting list items
public struct ListParameters: Parameterable {
    /// Pagination parameter to skip first n transactions from list, default = 0
    public var skip: Int?
    /// Pagination parameter to limit output to n , default = 100 , maximum value = 1000
    public var limit: Int?
    /// To only fetch transactions related to particular subscription
    public var subscription_id: String?
    /// ID of a gateway with which charges were created
    public var gateway_id: String?
    /// ID of a company with which charges were created
    public var company_id: String?
    /// Parameter to set range of created transactions date
    public var createdAtFrom: Date?
    /// Parameter to set range of created transactions date
    public var createdAtTo: Date?
    /// Word of phrase Customer want to search in created charges (search works by fields: First, Last names and Emails)
    public var search: String?
    /// Status could be: complete, failed, archived, requested, refund_requested, refunded, inprogress
    public var status: String?
    /// Set to true to show all the archived charges. Default: false
    public var isArchived: Bool?
    /// Generated backend side jwt token with search query with public key
    public var queryToken: String?
    
    public init(skip: Int?, limit: Int?, subscription_id: String?, gateway_id: String?, company_id: String?, createdAtFrom: Date?, createdAtTo: Date?, search: String?, status: String?, isArchived: Bool?, queryToken: String?) {
        self.skip = skip
        self.limit = limit
        self.subscription_id = subscription_id
        self.gateway_id = gateway_id
        self.company_id = company_id
        self.createdAtFrom = createdAtFrom
        self.createdAtTo = createdAtTo
        self.search = search
        self.status = status
        self.isArchived = isArchived
        self.queryToken = queryToken
    }

    public func toDictionary() -> [String : Any] {
        var param: [String: Any] = [:]
        param.appendNonNilable(key: "skip", item: skip)
        param.appendNonNilable(key: "limit", item: limit)
        param.appendNonNilable(key: "subscription_id", item: subscription_id)
        param.appendNonNilable(key: "gateway_id", item: gateway_id)
        param.appendNonNilable(key: "company_id", item: company_id)
        param.appendNonNilable(key: "created_at.from", item: createdAtFrom?.toUTCString())
        param.appendNonNilable(key: "created_at.to", item: createdAtTo?.toUTCString())
        param.appendNonNilable(key: "search", item: search)
        param.appendNonNilable(key: "status", item: status)
        param.appendNonNilable(key: "archived", item: isArchived)
        param.appendNonNilable(key: "query_token", item: queryToken)
        return param
    }
}
