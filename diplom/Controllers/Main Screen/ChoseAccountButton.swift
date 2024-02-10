//
//  choseAccountButton.swift
//  diplom
//
//  Created by Dulin Gleb on 29.11.23..
//

import UIKit

@IBDesignable
class ChoseAccountButton: UIButton {
    
    private let leftImageSize = 20.0
    private let arrowImageSize = 12.0
    private let spacing: CGFloat = 8.0
    private let buttonHeight = 36.0
    private var buttonWidth: Double?
    var floatingWidth: Bool = true
    
    
    private var hasArrow: Bool = true {
        didSet {
            if hasArrow == true {
                rightImageView.isHidden = false
            } else {
                rightImageView.isHidden = true
            }
        }
    }
    
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
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        var newTitle = title
        
        if let width = buttonWidth, let buttonText = title, let buttonFont = titleLabel?.font {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: buttonFont
            ]
            
            let textSize = (buttonText as NSString).size(withAttributes: attributes)
            
            let maxTitleWidth = width - spacing * 3 - (leftImage != nil ? leftImageView.frame.width + spacing : 0)
            
            if textSize.width > maxTitleWidth {
                newTitle = buttonText.truncated(toWidth: maxTitleWidth, withFont: buttonFont)
            }
            
            print (textSize.width, maxTitleWidth)
        }
        
        super.setTitle(newTitle, for: state)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        leftImageView.frame.size.width = leftImageSize
        leftImageView.frame.size.height = leftImageSize
        leftImageView.frame.origin.x = -leftImageSize - spacing
        
        titleLabel?.insertSubview(leftImageView, at: 0)
        
        rightImageView.frame.size.width = arrowImageSize
        rightImageView.frame.size.height = arrowImageSize
        rightImageView.frame.origin.x = self.bounds.width - arrowImageSize - spacing
        rightImageView.frame.origin.y = (self.bounds.height / 2) - (arrowImageSize / 2)
        
    }

    private func setupButton() {
        tintColor = .quaternarySystemFill
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .highlighted)
        
        configuration?.cornerStyle = .capsule
        
        addSubview(leftImageView)
        addSubview(rightImageView)
        
        rightImageView.image = rightImage
        updateButton()
    }
    
    private func updateButton() {
       configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: leftImageSize + spacing * 2, bottom: 8, trailing: hasArrow ? arrowImageSize + spacing * 2 : spacing)
    }
    
    public func setLeftImage(leftImage: UIImage, tintColor: UIColor) {
        self.leftImage = leftImage
        self.leftImageView.tintColor = tintColor
    }
    
    public func setRightArrow(_ hasArrow: Bool = true) {
        self.hasArrow = hasArrow
        updateButton()
    }
    
    public func setButtonWidth(_ width: Double? = nil) {
        self.buttonWidth = width
    }
    

}
