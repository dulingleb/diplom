//
//  SettingNumberTableViewCell.swift
//  diplom
//
//  Created by Dulin Gleb on 13.1.24..
//

import UIKit

protocol SettingNumberTextFieldDelegate: AnyObject {
    func settingNumberTextFieldDidChange(_ number: Double)
}

class SettingNumberTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "SettingNumberTableViewCell"
    
    weak var numberTFDelegate: SettingNumberTextFieldDelegate?

    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let numberTF: UITextField = {
        let number = UITextField()
        number.borderStyle = .none
        number.placeholder = "0"
        number.textAlignment = .right
        number.keyboardType = .decimalPad
        return number
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(numberTF)
        numberTF.delegate = self
        
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 16, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(
            x: iconContainer.frame.size.width / 2 - imageSize / 2,
            y: iconContainer.frame.size.height / 2 - imageSize / 2,
            width: imageSize,
            height: imageSize
        )
        
        let xLabelPos = self.iconImageView.image == nil ? 0 : iconContainer.frame.size.width + 8
        
        label.frame = CGRect(
            x: 16 + xLabelPos,
            y: 0,
            width: contentView.frame.size.width - 16 - iconContainer.frame.size.width - 100,
            height: contentView.frame.size.height
        )
        
        numberTF.frame = CGRect(
            x: contentView.frame.size.width - 100 - 16,
            y: 0,
            width: 100,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        numberTF.text = nil
        iconContainer.backgroundColor = nil
    }
    
    public func configure(with model: SettingNumberOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        numberTF.text = (model.number != nil) ? String(model.number ?? 0) : nil
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = numberTF.text else {
            return true
        }

        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        return updatedText.count <= 7
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let number: Double = Double(textField.text ?? "0") ?? 0
        numberTFDelegate?.settingNumberTextFieldDidChange(number)
    }

}
