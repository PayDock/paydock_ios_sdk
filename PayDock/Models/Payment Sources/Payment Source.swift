//
//  Payment Source.swift
//  PayDock
//
//  Created by RTA on 19/4/17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import Foundation


/// model for Payment Source
///
/// - card: if source is card
/// - bankAccount: if source is bank account
/// - bsb: if source is bsb
public enum PaymentSource: Parameterable, Mapable {
    
    case card(value: Card)
    case bankAccount(value: BankAccount)
    case bsb(value: BSB)
    case checkout(value: Checkout)
    
    typealias Kind = PaymentSource
    
    public func toDictionary() -> [String : Any] {
        switch self {
        case .card(let card):
            return card.toDictionary()
        case .bankAccount(let bankAccount):
            return bankAccount.toDictionary()
        case .bsb(let bsb):
            return bsb.toDictionary()
        case .checkout(let checkout):
            return checkout.toDictionary()
        }
    }
    
    
    init(json: Dictionary<String, Any>) throws {
        if let _: String? = (try? json.value(for: "card_name")) {
            let card: Card = try Card(json: json)
            self = PaymentSource.card(value: card)
            return
        } else if let _: String? = try? json.value(for: "account_bsb") {
            let bsb: BSB = try BSB(json: json)
            self = PaymentSource.bsb(value: bsb)
            return
        } else if let _: String? = try? json.value(for: "account_holder_type") {
            let account: BankAccount = try BankAccount(json: json)
            self = PaymentSource.bankAccount(value: account)
            return
        } else if let type: String? = try? json.value(for: "type") {
            if type == "card" {
                let card: Card = try Card(json: json)
                self = PaymentSource.card(value: card)
            return
            } else if type == "bsb" {
                let bsb: BSB = try BSB(json: json)
                self = PaymentSource.bsb(value: bsb)
            return
            } else if type == "bank_account" {
                let account: BankAccount = try BankAccount(json: json)
                self = PaymentSource.bankAccount(value: account)
            return
            } else if type == "checkout" {
                let checkout: Checkout = try Checkout(json: json)
                self = PaymentSource.checkout(value: checkout)
                
            return
            }
        }
	
        throw Errors.parsingFailed
    }
    
    
}
