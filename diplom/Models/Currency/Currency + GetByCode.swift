//
//  Currency + GetByCode.swift
//  diplom
//
//  Created by Dulin Gleb on 15.1.24..
//

import Foundation
import RealmSwift

extension Currency {
    static func getByCode(_ code: String) -> Currency? {
        do {
            let realm = try Realm()
            return realm.objects(Currency.self).filter("code == %@", code).first
        } catch {
            print("Failed to access Realm: \(error)")
            return nil
        }
    }
}
