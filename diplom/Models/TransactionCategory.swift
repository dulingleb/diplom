//
//  TransactionCategory.swift
//  diplom
//
//  Created by Dulin Gleb on 14.1.24..
//

import Foundation
import RealmSwift
import UIKit

class TransactionCategory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var iconName: String = "bag"
    @Persisted var iconColor: String = UIColor.systemBlue.toHexString
    @Persisted var pos: Int = 0
    @Persisted var type: String = TransactionType.expense.rawValue
    
    @Persisted var transactions: List<Transaction>
    
    public func getTransactionsByMonth(date: Date = Date()) -> Results<Transaction> {
        return self.transactions.filter("date >= %@ AND date <= %@", date.startOfMonth, date.endOfMonth)
    }
}
