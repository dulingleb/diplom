//
//  UIViewController + Alert.swift
//  diplom
//
//  Created by Dulin Gleb on 7.2.24..
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(title: String, message: String, confirmButtonTitle: String = "Delete", cancelButtonTitle: String = "Cancel", onConfirm: @escaping () -> Void) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Добавление кнопки подтверждения с обработчиком
            let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .destructive) { _ in
                onConfirm()
            }
            alert.addAction(confirmAction)
            
            // Добавление кнопки отмены
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            // Показать алерт
            self.present(alert, animated: true, completion: nil)
        }
}
