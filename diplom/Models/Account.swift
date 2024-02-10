//
//  Account.swift
//  diplom
//
//  Created by Dulin Gleb on 5.1.24..
//

import Foundation
import RealmSwift
import UIKit

enum AccountType: String {
    case forExpense = "Expense"
    case forIncome = "Income"
}

class Account: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var iconName: String = "wallet"
    @Persisted var iconColor: String = UIColor.systemBlue.toHexString
    @Persisted var balance: Double = 0.0
    @Persisted var type: String = AccountType.forExpense.rawValue
    @Persisted var currency: Currency?
    
    @Persisted var transactions: List<Transaction>
    
    public func getCurrentBalance() -> Double {
        var balance = self.balance
        
        for transaction in transactions {
            if transaction.type == TransactionType.income.rawValue {
                balance += transaction.amount
            } else {
                balance -= transaction.amount
            }
        }
        
        return balance
    }
}
