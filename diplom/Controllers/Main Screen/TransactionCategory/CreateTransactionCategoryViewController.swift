//
//  CreateExpenseCategoryViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 31.1.24..
//

import UIKit
import RealmSwift

class CreateTransactionCategoryViewController: UIViewController, UITextFieldDelegate, IconsSelectionDelegate {

    var typeOfCategory: TransactionType = .expense
    private let nameTF: UITextField = UITextField()
    
    private var saveButton: UIButton!
    private var saveButtonConstraint: NSLayoutConstraint!
    
    private let iconView = AccountIconContainer()
    private var iconName: String?
    private var iconColor: UIColor = .systemOrange
    
    var categoryCallback: ((TransactionCategory) -> Void)?
    var type: TransactionType
    
    init(type: TransactionType = .expense) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
           
        uiSetup()
        navigationItemSetup()
    }
    
    private func uiSetup() {
        self.title = "New Expense Category"
        view.backgroundColor = .secondarySystemBackground
        
        // Название счета
        nameTF.placeholder = typeOfCategory.rawValue + " Category Name"
        nameTF.borderStyle = .none
        nameTF.backgroundColor = .secondarySystemBackground
        nameTF.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        nameTF.textAlignment = .center
        nameTF.delegate = self
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTF)
        
        // Icon
        iconView.configure(name: "wallet", color: self.iconColor)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChooseIcon)))
        view.addSubview(iconView)
        
        let choseIconLabel = UILabel()
        choseIconLabel.text = "Change icon"
        choseIconLabel.font = UIFont.systemFont(ofSize: 12)
        choseIconLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6)
        choseIconLabel.textAlignment = .center
        choseIconLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(choseIconLabel)
        
        // Save Button
        var saveButtonConfig = UIButton.Configuration.filled()
        saveButtonConfig.cornerStyle = .capsule
        saveButton = UIButton(configuration: saveButtonConfig)
        saveButton.setTitle("Save", for: .normal)
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        saveButtonConstraint = saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28)
        saveButtonConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        NSLayoutConstraint.activate([
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTF.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 36),
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            
            choseIconLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            choseIconLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

    private func navigationItemSetup() {
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeButtonTapped()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    
    
    func iconDidSelected(iconName: String, color: UIColor) {
        self.iconName = iconName
        self.iconColor = color
        
        self.iconView.configure(name: iconName, color: color)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        saveButton.isEnabled = count == 0 ? false : true
    }
    
    
    @objc func saveButtonTapped() {
        let category = TransactionCategory()
        category.name = self.nameTF.text ?? "New Category"
        category.iconName = self.iconName ?? "wallet"
        category.iconColor = self.iconColor.toHexString
        category.type = self.type.rawValue
        
        StorageManager.shared.addTransactionCategory(category: category)
        
        self.categoryCallback?(category)
        dismiss(animated: true)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func openChooseIcon() {
        let choseIconVC = ChoseIconViewController()
        choseIconVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: choseIconVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.large()]
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        self.navigationController?.present(navigationVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            saveButtonConstraint.constant = -keyboardSize.height - 28
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        saveButtonConstraint.constant = -28
        view.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
