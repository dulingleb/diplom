//
//  MainViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 27.11.23..
//

import UIKit

class AddTransactionViewController: UIViewController, KeyboardPadCollectionViewDelegate {
    
    var amount: Double = 0
    var amountString: String = "0" {
        didSet {
            if Double(amountString.replacingOccurrences(of: ",", with: "")) ?? 0 > 999999999.99 {
                amountString = oldValue
            }
            
            amountString = amountString.insertCommas()
            
            amountLabel.text = amountPrefix + amountString
            
            adjustFontSize(for: amountLabel)

            
        }
        
        willSet {
            if newValue == "0" {
                amountLabel.textColor = .opaqueSeparator
                callendarButton.isEnabled = false
                callendarButton.imageView?.alpha = 0.4
                commentButton.isEnabled = false
                commentButton.imageView?.alpha = 0.4
                addTransactionButton.isEnabled = false
            } else {
                amountLabel.textColor = .black
                callendarButton.isEnabled = true
                callendarButton.imageView?.alpha = 1
                commentButton.isEnabled = true
                commentButton.imageView?.alpha = 1
                addTransactionButton.isEnabled = true
            }
        }
    }
    var amountPrefix: String = "$"
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var choseAccountButton: ChoseAccountButton!
    @IBOutlet weak var choseIncomeCattegoryButton: ChoseAccountButton!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var accountButtonsView: UIStackView!
    
    @IBOutlet weak var keboardCollectionView: KeyboardPadCollectionView!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var callendarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keboardCollectionView.keyboardPadCollectionViewDelegate = self
        setupUI()
    }
    
    private func setupUI() {
        let iconForAccount: UIImage = UIImage(named: "money") ?? UIImage(systemName: "briefcase")!
        choseAccountButton.leftImage = iconForAccount
        choseAccountButton.hasArrow = true
        choseAccountButton.setTitle("Category", for: .normal)
        
        let iconForIncome: UIImage = UIImage(named: "briefcase") ?? UIImage(systemName: "briefcase")!
        choseIncomeCattegoryButton.leftImage = iconForIncome
        choseIncomeCattegoryButton.hasArrow = false
        choseIncomeCattegoryButton.setTitle("Salary", for: .normal)
        
        accountButtonsView.axis = .vertical
        accountButtonsView.alignment = .center
        accountButtonsView.distribution = .fill
        
        callendarButton.imageView?.alpha = 0.5
        commentButton.imageView?.alpha = 0.5
    }
    
    @IBAction func typeTransactionSegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            choseIncomeCattegoryButton.isHidden = true
            arrowImage.isHidden = true
            
            choseAccountButton.hasArrow = true
            
            accountButtonsView.axis = .vertical
            accountButtonsView.alignment = .center
            accountButtonsView.distribution = .fill
        } else {
            choseIncomeCattegoryButton.isHidden = false
            
            choseAccountButton.hasArrow = false
            
            arrowImage.isHidden = false
            arrowImage.contentMode = .scaleAspectFit
            
            choseIncomeCattegoryButton.widthAnchor.constraint(equalTo: choseAccountButton.widthAnchor).isActive = true
            
            accountButtonsView.axis = .horizontal
            accountButtonsView.distribution = .fill
            accountButtonsView.alignment = .center
            accountButtonsView.spacing = 8
        }
    }
    
    @IBAction func choseAccountButtonClick(_ sender: Any) {
        choseAccountButton.setTitle("As", for: .normal)
        amountString = "0"
        amountLabel.text = amountString
    }
    
    func didSelectItem(withTitle title: String) {
        if title == "." && amountString.contains(".") {return}
        
        if !amountString.hasValidDecimalPlaces() {return}
        
        if title != "." && !amountString.contains(".") {
            amountString = amountString.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }        
        
        amountString += title
    }
    
    func didBackspace() {
        if amountString.count > 1 {
            amountString.removeLast()
        } else {
            amountString = "0"
        }
    }
    
    func adjustFontSize(for label: UILabel) {
        let maxFontSize: CGFloat = 70 // Максимальный размер шрифта, который вы хотите использовать
        let minFontSize: CGFloat = 10 // Минимальный размер шрифта, который вы хотите использовать

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = minFontSize / maxFontSize // Установка минимального масштаба для текста

        var fontSize = maxFontSize
        var textWidth: CGFloat = 0

        repeat {
            fontSize -= 1
            label.font = label.font.withSize(fontSize)
            textWidth = label.intrinsicContentSize.width
        } while fontSize > minFontSize && textWidth > label.bounds.size.width

        // Если текст слишком маленький для максимального размера шрифта, увеличим его
        if textWidth < label.bounds.size.width && fontSize < maxFontSize {
            repeat {
                fontSize += 1
                label.font = label.font.withSize(fontSize)
                textWidth = label.intrinsicContentSize.width
            } while textWidth < label.bounds.size.width && fontSize < maxFontSize
        }
    }
    
}
