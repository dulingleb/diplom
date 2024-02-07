//
//  UIView + topBarHeight.swift
//  diplom
//
//  Created by Dulin Gleb on 2.2.24..
//

import Foundation
import UIKit

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topBarHeight: CGFloat {
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        var statusBarHeight: CGFloat = 0.0

        // Находим активную UIWindowScene
        let windowScene = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first as? UIWindowScene
        // Получаем высоту статус-бара через statusBarManager
        statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        
        return navBarHeight + statusBarHeight
    }
}
