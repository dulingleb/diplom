//
//  CloseButton.swift
//  diplom
//
//  Created by Dulin Gleb on 10.1.24..
//

import UIKit

class CloseButton: UIButton {

    var closeButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        // Устанавливаем собственное изображение для кнопки
        if let image = UIImage(systemName: "xmark") {
            let newSize = CGSize(width: 12, height: 12) // Новый размер изображения
            let scaledImage = image.resized(to: newSize)?
                .withTintColor(UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6)) // Изменяем размер изображения и цвет
            

            setImage(scaledImage, for: .normal) // Устанавливаем изображение на кнопку
        }
        
        backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.5, alpha: 0.12)
        layer.cornerRadius = 12

        addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    @objc private func closeTapped() {
        // Вызываем обратный вызов (closure) при нажатии на кнопку
        closeButtonAction?()
    }

}
