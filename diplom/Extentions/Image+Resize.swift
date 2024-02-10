//
//  Image+Resize.swift
//  diplom
//
//  Created by Dulin Gleb on 6.1.24..
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
