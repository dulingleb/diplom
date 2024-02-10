//
//  ContextMenu.swift
//  diplom
//
//  Created by Dulin Gleb on 8.2.24..
//

import Foundation
import UIKit

struct ContextMenuItem {
    var title: String = ""
    var image: UIImage?
    var handler: ((IndexPath) -> Void)?
}
