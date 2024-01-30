//
//  CollorCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 17.1.24..
//

import UIKit

class CollorCollectionViewCell: UICollectionViewCell {
    static public let reuseId: String = "ColorCell"
    
    private let backgroundLayer = UIView()
    private let backgroundLayerWhite = UIView()
    
    override var isSelected: Bool {
        didSet {
            backgroundLayer.backgroundColor = self.backgroundColor
            backgroundLayerWhite.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundLayer() {
        self.layer.cornerRadius = self.frame.size.width / 2
        
        backgroundLayerWhite.layer.cornerRadius = (self.frame.size.width - 4) / 2
        backgroundLayerWhite.frame.size.width = self.frame.size.width - 4
        backgroundLayerWhite.frame.size.height = self.frame.size.height - 4
        backgroundLayerWhite.backgroundColor = .secondarySystemBackground
        backgroundLayerWhite.center = contentView.center
        addSubview(backgroundLayerWhite)
        
        
        
        let innerCircleSize = backgroundLayerWhite.frame.size.width - 6
        let centerInnercCirlceSize = (backgroundLayerWhite.frame.size.width / 2) - (innerCircleSize / 2)
        
        backgroundLayer.frame = CGRect(
            x: centerInnercCirlceSize,
            y: centerInnercCirlceSize,
            width: innerCircleSize,
            height: innerCircleSize
        )
        
        backgroundLayer.layer.cornerRadius = innerCircleSize / 2
        
        backgroundLayerWhite.addSubview(backgroundLayer)
        
        
        backgroundLayerWhite.isHidden = true
    }
}
