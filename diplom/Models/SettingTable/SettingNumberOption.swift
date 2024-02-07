//
//  SettingNumberOption.swift
//  diplom
//
//  Created by Dulin Gleb on 12.1.24..
//

import Foundation
import UIKit

struct SettingNumberOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor?
    let number: Double?
    let handler: (() -> Void)?
    let endEditingHandler: (() -> Void)?
    
    init(title: String, number: Double, icon: UIImage, iconBacgroundColor: UIColor, handler: @escaping (() -> Void), endEditingHandler: @escaping (() -> Void)) {
        self.title = title
        self.number = number
        self.icon = icon
        self.iconBackgroundColor = iconBacgroundColor
        self.handler = handler
        self.endEditingHandler = endEditingHandler
    }
    
    init(title: String, number: Double?) {
        self.title = title
        self.number = number
        self.icon = nil
        self.iconBackgroundColor = nil
        self.handler = nil
        self.endEditingHandler = nil
    }
}
