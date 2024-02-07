//
//  Section.swift
//  diplom
//
//  Created by Dulin Gleb on 12.1.24..
//

import Foundation

enum SettingsOptionType {
    case staticCell(model: SettingOption)
    case switchCell(model: SettingSwitchOption)
    case numberCell(model: SettingNumberOption)
}

struct Section {
    let title: String
    let options: [SettingsOptionType]
}
