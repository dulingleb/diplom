//
//  AccountsCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 1.2.24..
//

import UIKit

class AccountsCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AccountsCell"
    
    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    private let symbolLabel = UILabel()
    private let iconView = UIImageView()
    private var icon = UIImage()
    
    private let iconSize: CGFloat = 28
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.layer.cornerRadius = 20
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        amountLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.textColor = .label
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amountLabel)
        
        symbolLabel.font = UIFont.systemFont(ofSize: 17)
        symbolLabel.textColor = .secondaryLabel
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(symbolLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconView.widthAnchor.constraint(equalToConstant: self.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: self.iconSize),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func config(name: String, amount: String, symbol: String, icon: String, iconColor: UIColor) {
        self.nameLabel.text = name
        self.amountLabel.text = amount
        self.symbolLabel.text = symbol
        self.iconView.image = UIImage(named: icon)
        self.iconView.tintColor = iconColor
    }
}
