//
//  UILabel + StringWidth.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import Foundation
import UIKit

extension UILabel {
    func getTextSize() -> CGSize {
        let textSize: CGSize
        if let text = self.text {
            let attributes: [NSAttributedString.Key: Any] = [.font: self.font]
            textSize = text.size(withAttributes: attributes)
        } else {
            textSize = .zero // Текст отсутствует, поэтому размер равен нулю
        }
        
        return textSize
    }
}
