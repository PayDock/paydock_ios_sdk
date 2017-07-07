//
//  Transaction.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation



/// transaction model
///
/// - sale: if Model is Sale
/// - refund: if Model is Refund
public enum Transaction: Mapable {
    case sale(value: Sale)
    case refund(value: Refund)
    public typealias Kind = Transaction
    init(json: Dictionary<String, Any>) throws {
        if let type: String = try? json.value(for: "type") {
            switch type {
            case "sale":
                let sale = try Sale(json: json)
                self = Transaction.sale(value: sale)
                return
            case "refund":
                let refund = try Refund(json: json)
                self = Transaction.refund(value: refund)
                return
            default:
                throw Errors.parsingFailed
            }
        }
        throw Errors.parsingFailed
    }
}
