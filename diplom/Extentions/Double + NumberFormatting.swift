//
//  Double + NumberFormatting.swift
//  diplom
//
//  Created by Dulin Gleb on 5.2.24..
//

import Foundation

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
