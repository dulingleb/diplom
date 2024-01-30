//
//  CloseButtonContainer.swift
//  diplom
//
//  Created by Dulin Gleb on 16.1.24..
//

import UIKit

class CloseButtonContainer: UIView {
    let closeButton = CloseButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        addSubview(closeButton)
        closeButton.frame = bounds

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
