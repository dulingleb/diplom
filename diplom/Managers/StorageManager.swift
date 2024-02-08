//
//  StorageManager.swift
//  diplom
//
//  Created by Dulin Gleb on 5.2.24..
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    private let realm = try! Realm()
    
    
    // Transactions
    public func addTransaction(_ transaction: Transaction) {
        do {
            try realm.write {
                if let category = transaction.category {
                    category.transactions.append(transaction)
                }
                
                if let account = transaction.account {
                    account.transactions.append(transaction)
                }
                
                realm.add(transaction)
            }
        } catch {
            print("error adding transactions \(error)")
        }
    }
    
    public func updateTransaction(withId id: ObjectId, updates: (Transaction) -> Void) {
        do {
            guard let transaction = realm.object(ofType: Transaction.self, forPrimaryKey: id) else { return }

            try realm.write {
                updates(transaction)
            }
        } catch {
            print("error updating category: \(error)")
        }
    }
    
    public func deleteTransaction(_ transaction: Transaction) {
        do {
            try realm.write {
                realm.delete(transaction)
            }
        } catch {
            print("error deleting transactions \(error)")
        }
    }
    
    // Categories
    public func getTransactionCategories(type: TransactionType = TransactionType.expense) -> Results<TransactionCategory> {
        return realm.objects(TransactionCategory.self).filter("type = %@", type.rawValue)
    }
    
    public func addTransactionCategory(category: TransactionCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error adding transactions \(error)")
        }
    }
    
    public func updateTransactionCategory(withId id: ObjectId, updates: (TransactionCategory) -> Void) {
        do {
            guard let category = realm.object(ofType: TransactionCategory.self, forPrimaryKey: id) else { return }

            try realm.write {
                updates(category)
            }
        } catch {
            print("error updating category: \(error)")
        }
    }
    
    public func deleteTransactionCategory(_ category: TransactionCategory) {
        do {
            try realm.write {
                realm.delete(category)
                
                let unusedTransactions = realm.objects(Transaction.self).filter("category = nil")
                realm.delete(unusedTransactions)
            }
        } catch {
            print("error deleting transaction category: \(error)")
        }
    }
    
    // Account
    public func getAccounts() -> Results<Account> {
        return realm.objects(Account.self)
    }
    
    public func addAccount(_ account: Account) {
        do {
            try realm.write {
                realm.add(account)
            }
        } catch {
            print("error adding account \(error)")
        }
    }
    
    public func updateAcount(withId id: ObjectId, updates: (Account) -> Void) {
        do {
            guard let account = realm.object(ofType: Account.self, forPrimaryKey: id) else { return }

            try realm.write {
                updates(account)
            }
        } catch {
            print("error updating account: \(error)")
        }
    }
    
    public func deleteAccount(_ account: Account) {
        do {
            try realm.write {
                realm.delete(account)
                
                let unusedTransactions = realm.objects(Transaction.self).filter("account = nil")
                realm.delete(unusedTransactions)
            }
        } catch {
            print("error deleting transaction category: \(error)")
        }
    }
    
    // Currency
    public func getCurrencies() -> Results<Currency> {
        return realm.objects(Currency.self)
    }
    
    public func addCurrency(_ currency: Currency) {
        do {
            try realm.write {
                realm.add(currency)
            }
        } catch {
            print("error adding currency \(error)")
        }
    }
}
