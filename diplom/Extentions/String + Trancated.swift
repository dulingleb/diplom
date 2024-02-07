//
//  String + Trancated.swift
//  diplom
//
//  Created by Dulin Gleb on 27.1.24..
//

import Foundation
import UIKit

extension String {
    func truncated(toWidth width: CGFloat, withFont font: UIFont) -> String {
        var currentWidth: CGFloat = 0
        var resultString = ""
        let ellipsis = "..."
        let ellipsisWidth = (ellipsis as NSString).size(withAttributes: [.font: font]).width
        
        for character in self {
            let characterString = String(character)
            let characterSize = (characterString as NSString).size(withAttributes: [.font: font])
            
            if currentWidth + characterSize.width > width - ellipsisWidth {
                resultString += ellipsis
                break
            }
            
            currentWidth += characterSize.width
            resultString += characterString
        }
        
        return resultString
    }
}
