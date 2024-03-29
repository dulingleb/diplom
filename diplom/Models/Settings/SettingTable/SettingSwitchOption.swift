//
//  SettingSwitchOption.swift
//  diplom
//
//  Created by Dulin Gleb on 12.1.24..
//

import Foundation
import UIKit

struct SettingSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    let isOn: Bool
}
