//
//  StatisticCategoriesCollectionViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 7.2.24..
//

import UIKit

class StatisticCategoriesCollectionViewCell: UICollectionViewCell {
    static let reuseID = "statisticCategoryCell"
    
    private let backgroundIcon: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 24
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.frame.size.width = 28
        iv.frame.size.height = 28
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let title = UILabel()
    private let amountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        backgroundIcon.addSubview(iconView)
        contentView.addSubview(backgroundIcon)
        
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(title)
        
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        contentView.addSubview(amountLabel)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            backgroundIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundIcon.widthAnchor.constraint(equalToConstant: 48),
            backgroundIcon.heightAnchor.constraint(equalToConstant: 48),
            backgroundIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            iconView.centerXAnchor.constraint(equalTo: backgroundIcon.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: backgroundIcon.centerYAnchor),
            
            title.topAnchor.constraint(equalTo: backgroundIcon.bottomAnchor, constant: 5),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        contentView.layer.cornerRadius = 14
    }
    
    public func config(title: String, iconName: String, iconColor: UIColor, amount: String) {
        self.backgroundIcon.backgroundColor = iconColor.withAlphaComponent(0.1)
        self.title.text = title
        self.iconView.image = UIImage(named: iconName) ?? UIImage(systemName: "folder")!
        self.iconView.tintColor = iconColor
        self.amountLabel.text = amount
    }
}
