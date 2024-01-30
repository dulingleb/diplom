//
//  IconHeaderCollectionReusableView.swift
//  diplom
//
//  Created by Dulin Gleb on 18.1.24..
//

import UIKit

class IconHeaderCollectionReusableView: UICollectionReusableView {
    static let reuseId = "iconHeaderCell"
    
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = bounds
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
