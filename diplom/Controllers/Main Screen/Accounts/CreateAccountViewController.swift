//
//  CreateAccountViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 9.1.24..
//

import UIKit
import RealmSwift

protocol CurrencySelectionDelegate: AnyObject {
    func currencyDidSelect(currency: Currency)
}

protocol IconsSelectionDelegate: AnyObject {
    func iconDidSelected(iconName: String, color: UIColor)
}

class CreateAccountViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CurrencySelectionDelegate, IconsSelectionDelegate, SettingNumberTextFieldDelegate {
    
    
    private let accountNameTF: UITextField = {
        let accountTF = UITextField()
        accountTF.placeholder = "Account Name"
        accountTF.borderStyle = .none
        accountTF.backgroundColor = .secondarySystemBackground
        accountTF.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        accountTF.textAlignment = .center
        return accountTF
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SettingNumberTableViewCell.self, forCellReuseIdentifier: SettingNumberTableViewCell.identifier)
        table.register(SettingSwitchTableViewCell.self, forCellReuseIdentifier: SettingSwitchTableViewCell.identifier)
        table.backgroundColor = .white
        table.layer.cornerRadius = 12
        return table
    }()
    
    private var balance: Double = 0
    
    let saveButton = SaveButton()
    var accountCallback: ((Account) -> Void)?
    
    private let iconView = AccountIconContainer()
    private var iconName: String?
    private var iconColor: UIColor = .systemOrange
    
    private var currency: Currency! {
        didSet {
            settingModels[0] = .staticCell(model: SettingOption(title: "Currency", info: "\(self.currency.symbol ?? "") - \(self.currency.code)", handler: {
                self.currencyCellHandler()
            }))
            tableView.reloadData()
        }
    }
    
    var settingModels = [SettingsOptionType]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        uiSetup()
        navigationItemSetup()
    }
    
    private func configure() {
        self.settingModels = [
            .staticCell(model: SettingOption(title: "Currency", info: "$ - USD", handler: {
                    self.currencyCellHandler()
                })),
            .numberCell(model: SettingNumberOption(title: "Balance", number: nil))
        ]
        
        
        let currencyCode = "USD"
        if let currency = StorageManager.shared.getCurrencies().filter("code == %@", currencyCode).first {
            self.currency = currency
        } else {
            print("Валюта с кодом \(currencyCode) не найдена.")
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // кастомизация контроллера
    private func uiSetup() {
        self.title = "Add Account"
        view.backgroundColor = .secondarySystemBackground
        
        // Название счета
        accountNameTF.delegate = self
        accountNameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountNameTF)
        
        // Icon
        view.addSubview(iconView)
        iconView.configure(name: "wallet", color: self.iconColor)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChooseIcon)))
        
        let choseIconLabel = UILabel()
        choseIconLabel.text = "Change icon"
        choseIconLabel.font = UIFont.systemFont(ofSize: 12)
        choseIconLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6)
        choseIconLabel.textAlignment = .center
        choseIconLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(choseIconLabel)
        
        // Таблица настроек
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            accountNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountNameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            accountNameTF.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: accountNameTF.bottomAnchor, constant: 36),
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            
            choseIconLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            choseIconLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: choseIconLabel.bottomAnchor, constant: 36),
            tableView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settingModels[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                print("error")
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingSwitchTableViewCell.identifier,
                for: indexPath
            ) as? SettingSwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
        case .numberCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingNumberTableViewCell.identifier,
                for: indexPath
            ) as? SettingNumberTableViewCell else {
                return UITableViewCell()
            }
            cell.numberTFDelegate = self
            cell.configure(with: model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = settingModels[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(_): break
        case .numberCell(_): break
            
        }
    }
    
    // кнопки закрыть и сохранить
    private func navigationItemSetup() {
        
        // Кнопка сохранения
        
        saveButton.saveButtonAction = { [weak self] in
            self?.saveButtonTapped()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.isEnabled = false
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeButtonTapped()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    func currencyDidSelect(currency: Currency) {
        self.currency = currency
    }
    
    func iconDidSelected(iconName: String, color: UIColor) {
        self.iconName = iconName
        self.iconColor = color
        
        self.iconView.configure(name: iconName, color: color)
    }
    
    func settingNumberTextFieldDidChange(_ number: Double) {
        self.balance = number
    }
    
    private func currencyCellHandler() {
        let currenciesVC = CurrenciesTableViewController()
        currenciesVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: currenciesVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.large()]
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        self.navigationController?.present(navigationVC, animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        saveButton.isEnabled = count == 0 ? false : true
    }
    
    @objc func saveButtonTapped() {
        let account = Account()
        account.name = accountNameTF.text ?? "New account"
        account.currency = self.currency
        account.iconName = self.iconName ?? "wallet"
        account.iconColor = self.iconColor.toHexString
        account.balance = Double(self.balance)
        
        StorageManager.shared.addAccount(account)
        
        accountCallback?(account)
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
}
