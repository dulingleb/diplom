//
//  IconCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 18.1.24..
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    static let reuseId = "iconCell"
    
    var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 1 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: .zero)
        imageView.frame.size.width = 28
        imageView.frame.size.height = 28
        imageView.center = contentView.center
        imageView.tintColor = .black
        contentView.addSubview(imageView)
        
        contentView.layer.cornerRadius = contentView.frame.size.width / 2
        contentView.layer.borderColor = CGColor(gray: 0, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
