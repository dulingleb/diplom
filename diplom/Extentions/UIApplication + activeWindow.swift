//
//  UIApplication + activeWindow.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import Foundation
import UIKit
import Toast

extension UIApplication {
    var activeWindow: UIWindow? {
        // Подход для iOS 13 и выше, где могут быть множественные сцены
        if #available(iOS 13.0, *) {
            return connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            // Возврат keyWindow для версий ниже iOS 13
            return keyWindow
        }
    }
    
    var globalToastStyle: ToastStyle {
       var style = ToastStyle()
        style.backgroundColor = .white
        style.titleColor = .black
        style.messageColor = .black
        style.shadowColor = UIColor.black.withAlphaComponent(0.2)
        style.displayShadow = true
        style.cornerRadius = 20
        return style
    }
    
}
