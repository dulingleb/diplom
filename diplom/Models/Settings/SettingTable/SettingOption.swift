//
//  SettingOption.swift
//  diplom
//
//  Created by Dulin Gleb on 12.1.24..
//

import Foundation
import UIKit

struct SettingOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor?
    let info: String?
    let handler: (() -> Void)
    
    init(title: String, info: String, icon: UIImage, iconBacgroundColor: UIColor, handler: @escaping (() -> Void)) {
        self.title = title
        self.info = info
        self.icon = icon
        self.iconBackgroundColor = iconBacgroundColor
        self.handler = handler
    }
    
    init(title: String, info: String, handler: @escaping (() -> Void)) {
        self.title = title
        self.info = info
        self.icon = nil
        self.iconBackgroundColor = nil
        self.handler = handler
    }
}
