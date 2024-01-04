//
//  String + CommaDecimalFormatting.swift
//  diplom
//
//  Created by Dulin Gleb on 1.1.24..
//

import Foundation

extension String {
    func insertCommas() -> String {
        var stringWithCommas = self
        let length = stringWithCommas.count
        
        var index = length - 3
        while index > 0 {
            stringWithCommas.insert(",", at: stringWithCommas.index(stringWithCommas.startIndex, offsetBy: index))
            index -= 3
        }
        
        return stringWithCommas
    }
}
