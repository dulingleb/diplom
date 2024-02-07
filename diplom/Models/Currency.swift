//
//  Currency.swift
//  diplom
//
//  Created by Dulin Gleb on 14.1.24..
//

import Foundation
import RealmSwift

class Currency: Object {
    @Persisted var name: String
    @Persisted var code: String
    @Persisted var symbol: String?
}
