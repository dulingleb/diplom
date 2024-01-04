//
//  String+Validation.swift
//  diplom
//
//  Created by Dulin Gleb on 16.12.23..
//

import Foundation

extension String {
    func hasValidDecimalPlaces() -> Bool {
        let separatedStrings = self.split(separator: ".")
        if separatedStrings.count == 2 {
            _ = String(separatedStrings[0]) // Первая подстрока до точки
            let afterDot = String(separatedStrings[1]) // Вторая подстрока после точки
            
            if afterDot.count >= 2 { return false }
        }
        
        return true
    }
}
