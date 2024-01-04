//
//  choseAccountButton.swift
//  diplom
//
//  Created by Dulin Gleb on 29.11.23..
//

import UIKit

@IBDesignable
class ChoseAccountButton: UIButton {
    
    var hasArrow: Bool = true {
        didSet {
            if hasArrow == true {
                rightImageView.isHidden = false
                labelIsCenter = false
            } else {
                rightImageView.isHidden = true
                labelIsCenter = true
            }
        }
    }
    
    var labelIsCenter = false

    let leftImageView = UIImageView()
    let rightImageView = UIImageView()
    
    var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
        }
    }
    
    var rightImage: UIImage? = UIImage(named: "arrow.down")
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 8
        
        // Расположение правого изображения
        if let rightImage = rightImage {
            rightImageView.frame = CGRect(x: bounds.width - rightImage.size.width - spacing, y: bounds.height / 2 - rightImage.size.height / 2, width: rightImage.size.width, height: rightImage.size.height)
        }
        
        // Расположение левого изображения
        if let leftImage = leftImage {
            let xCenter = bounds.width / 2 - (titleLabel?.intrinsicContentSize.width ?? 0) / 2 - leftImage.size.width / 2 - spacing / 2
            let xRight = spacing
            
            leftImageView.frame = CGRect(
                x: labelIsCenter ? xCenter : xRight,
                y: bounds.height / 2 - leftImage.size.height / 2,
                width: leftImage.size.width,
                height: leftImage.size.height)
        }
        
        // Расчет ширины текста и обновление размеров кнопки
        if let titleLabel = titleLabel {
            let totalWidth = leftImageView.frame.width + rightImageView.frame.width + spacing * 4 + titleLabel.intrinsicContentSize.width
            if totalWidth > bounds.width {
                bounds.size.width = totalWidth
            }
        }
        
        // Пересчет положения текста
        if let textLabel = titleLabel {
            let xOffsetCenter = (bounds.width - textLabel.frame.width) / 2 + (leftImage?.size.width ?? 0) / 2 + spacing / 2
            let xOffsetRight = (leftImage?.size.width ?? 0) + spacing * 2
            textLabel.frame.origin.x = labelIsCenter ? xOffsetCenter : xOffsetRight
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    func setupButton() {
        tintColor = .quaternarySystemFill
        setTitleColor(.black, for: .normal)
        configuration?.cornerStyle = .capsule
        sizeToFit()
        configuration?.titleLineBreakMode = .byTruncatingTail
        
        rightImageView.image = rightImage
        
        addSubview(leftImageView)
        addSubview(rightImageView)
        
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
       

    }
    

}
