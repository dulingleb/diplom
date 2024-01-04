//
//  String + CommaDecimalFormatting.swift
//  diplom
//
//  Created by Dulin Gleb on 1.1.24..
//

import Foundation

extension String {
    func insertCommas() -> String {
        let components = self.components(separatedBy: ".")
            let numberString = components[0].replacingOccurrences(of: ",", with: "")
            let decimalPart = components.count > 1 ? "." + components[1] : ""

            var formattedString = ""
            var index = numberString.count - 1
            var counter = 0
            
            while index >= 0 {
                let currentChar = String(numberString[numberString.index(numberString.startIndex, offsetBy: index)])
                formattedString = currentChar + formattedString
                counter += 1
                
                if counter == 3 && index != 0 {
                    formattedString = "," + formattedString
                    counter = 0
                }
                
                index -= 1
            }
            
            return formattedString + decimalPart
    }
}
