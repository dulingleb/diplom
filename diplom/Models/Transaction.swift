//
//  Transaction.swift
//  diplom
//
//  Created by Dulin Gleb on 14.1.24..
//

import Foundation
import RealmSwift

enum TransactionType: String {
    case income = "Income"
    case expense = "Expense"
}

class Transaction: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var amount: Double
    @Persisted var date: Date = Date()
    @Persisted var comment: String?
    @Persisted var type: String = TransactionType.expense.rawValue
    @Persisted var category: TransactionCategory?
    @Persisted var account: Account?
}
