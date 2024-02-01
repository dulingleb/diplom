//
//  SaveButton.swift
//  diplom
//
//  Created by Dulin Gleb on 10.1.24..
//

import UIKit

class SaveButton: UIButton {
    var saveButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        setTitle("Save", for: .normal)
        
        var configuration = UIButton.Configuration.filled() // there are several options to choose from instead of .plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.cornerStyle = .capsule
        self.configuration = configuration

        addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() {
        
        // Вызываем обратный вызов (closure) при нажатии на кнопку
        saveButtonAction?()
    }

}
