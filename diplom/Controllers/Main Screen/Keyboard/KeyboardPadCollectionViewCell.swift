//
//  KeyboardPadCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 4.12.23..
//

import UIKit

class KeyboardPadCollectionViewCell: UICollectionViewCell {
    
    var keyboardButtonType: KeyboardButtonType = .digit
    
    let textLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.font = .systemFont(ofSize: 24, weight: .semibold)
        return tl
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(withText text: String?) {
        textLabel.text = text
        
        if text == "." {
            textLabel.font = .systemFont(ofSize: 24, weight: .black)
        }
        
        textLabel.isHidden = text == nil
        imageView.isHidden = true
    }
    
    func configure(withImage image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        textLabel.isHidden = true
    }

}
