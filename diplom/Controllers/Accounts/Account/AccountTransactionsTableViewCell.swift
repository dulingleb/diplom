//
//  AccountTransactionsTableViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import UIKit

class AccountTransactionsTableViewCell: UITableViewCell {
    static let reuseId = "AccountTransactionsCell"

    private let spacing = 20.0
    private let iconView = UIImageView()
    private let categoryLabel = UILabel()
    private let noteLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(amountLabel)
        
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
//        noteLabel.translatesAutoresizingMaskIntoConstraints = false
//        amountLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        setupUI()
        
    }
    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            iconView.widthAnchor.constraint(equalToConstant: 28),
//            iconView.heightAnchor.constraint(equalToConstant: 28),
//            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
//            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
//            
//            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
//            amountLabel.widthAnchor.constraint(equalToConstant: amountLabel.getTextSize().width + 1),
//            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
//            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
//            categoryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 18),
//            categoryLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: 18),
//        ])
//    }
    
    func setupUI() {
        iconView.frame = CGRect(x: spacing, y: contentView.center.y - 14, width: 28, height: 28)
        amountLabel.frame = CGRect(
            x: contentView.frame.width - amountLabel.getTextSize().width - 1 - spacing,
            y: 0,
            width: amountLabel.getTextSize().width + 1,
            height: contentView.frame.height
        )
        categoryLabel.frame = CGRect(
            x: iconView.frame.width + spacing * 2,
            y: 0,
            width: contentView.frame.width - spacing * 4 - amountLabel.frame.width,
            height: contentView.frame.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.amountLabel.textColor = .black
        //setupUI()
    }
    
    public func config(title: String, iconName: String, iconColor: UIColor, amount: String, amountType: String) {
        self.categoryLabel.text = title
        self.iconView.image = UIImage(named: iconName)
        self.iconView.tintColor = iconColor
        self.amountLabel.text = (amountType == TransactionType.income.rawValue ? "+" : "-") + amount
        
        self.amountLabel.textColor = (amountType == TransactionType.income.rawValue ? .systemGreen : .black)
        
        
    }
}
