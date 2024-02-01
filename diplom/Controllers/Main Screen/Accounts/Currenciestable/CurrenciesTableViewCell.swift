//
//  CurrenciesTableViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 15.1.24..
//

import UIKit

class CurrenciesTableViewCell: UITableViewCell {
    
    static let reuseId = "CurrencyCell"
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(codeLabel)
        addSubview(nameLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        codeLabel.frame = CGRect(
            x: 16,
            y: 0,
            width: 100,
            height: contentView.frame.size.height
        )
        
        nameLabel.frame = CGRect(
            x: codeLabel.frame.size.width + 16,
            y: 0,
            width: contentView.frame.size.width - 100 - 32,
            height: contentView.frame.size.height
        )
    }
    
    public func configure(with data: Currency) {
        codeLabel.text = data.code
        nameLabel.text = data.name
    }

}
