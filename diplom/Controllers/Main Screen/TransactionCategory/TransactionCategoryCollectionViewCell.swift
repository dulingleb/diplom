//
//  TransactionCategoryCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 30.1.24..
//

import UIKit

class TransactionCategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = "transactionCategoryCell"
    
    private let iconView = UIImageView()
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        iconView.contentMode = .scaleAspectFit
        iconView.frame.size.width = 28
        iconView.frame.size.height = 28
        contentView.addSubview(iconView)
        
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(title)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
    }
    
    public func config(title: String, iconName: String, iconColor: UIColor, textColor: UIColor = .black) {
        self.title.text = title
        self.iconView.image = UIImage(named: iconName) ?? UIImage(systemName: "folder")!
        self.iconView.tintColor = iconColor
        self.title.textColor = textColor
    }
}
