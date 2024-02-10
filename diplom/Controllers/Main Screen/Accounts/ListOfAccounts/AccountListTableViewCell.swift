//
//  AccountListTableViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 6.1.24..
//

import UIKit

class AccountListTableViewCell: UITableViewCell {
    
    static let reuseId = "accountCell"
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let selectedImageView = UIImageView()
    
    var isCurrentAccount: Bool = false {
        willSet {
            selectedImageView.isHidden = isCurrentAccount
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: AccountListTableViewCell.reuseId)
        
        iconImageView.frame = CGRect(x: 16, y: (frame.height - 24) / 2, width: 24, height: 24)
        addSubview(iconImageView)

        // Настройка заголовка (текста)
        titleLabel.frame = CGRect(x: 52, y: (frame.height - 24) / 2, width: 150, height: 24)
        addSubview(titleLabel)

        // Настройка правого изображения

        selectedImageView.frame = CGRect(x: frame.width, y: (frame.height - 14) / 2, width: 20, height: 14)
        selectedImageView.image = UIImage(systemName: "checkmark")
        addSubview(selectedImageView)
        selectedImageView.isHidden = true
        
        uiCellConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        uiCellConfig()
    }
    
    private func uiCellConfig() {
        self.titleLabel.textColor = .black
        self.backgroundColor = .white
        self.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 16)
    }

}
