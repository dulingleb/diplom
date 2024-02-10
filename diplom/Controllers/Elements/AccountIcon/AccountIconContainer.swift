//
//  AccountIconContainer.swift
//  diplom
//
//  Created by Dulin Gleb on 17.1.24..
//

import UIKit

class AccountIconContainer: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size.width = 40
        imageView.frame.size.height = 40
        return imageView
    }()
    
    private var icon = UIImage()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size.width = 100
        self.frame.size.height = 100
        self.backgroundColor = .white
        self.layer.borderColor = CGColor(red: 0.47, green: 0.47, blue: 0.5, alpha: 0.2)
        self.layer.cornerRadius = 50
        self.layer.borderWidth = 1
        
        addSubview(imageView)
        imageView.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(name: String, color: UIColor) {
        self.imageView.tintColor = color
        self.imageView.image = UIImage(named: name)
    }
    
}
