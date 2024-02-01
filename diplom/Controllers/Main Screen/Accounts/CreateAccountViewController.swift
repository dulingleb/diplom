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
    
    private var balance: Int = 0
    
    let saveButton = SaveButton()
    
    private let iconView = AccountIconContainer()
    private var iconName: String?
    private var iconColor: UIColor?
    
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
            .numberCell(model: SettingNumberOption(title: "Balance", number: nil) {
                print("hren")
            })
        ]
        
        let realm = try! Realm()
        let currencyCode = "USD"
        if let currency = realm.objects(Currency.self).filter("code == %@", currencyCode).first {
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
        iconView.configure(name: "wallet", color: .systemOrange)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChooseIcon)))
        
        // Таблица настроек
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            accountNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountNameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            accountNameTF.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: accountNameTF.bottomAnchor, constant: 36),
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 36),
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
        case .switchCell(let model): break
        case .numberCell(let model): break
            
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
    
    func settingNumberTextFieldDidChange(_ number: Int) {
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
        account.iconColor = self.iconColor?.toHexString ?? "000000"
        account.balance = Double(balance)
        
        let realm = try! Realm()
        // Open a thread-safe transaction.
        try! realm.write {
            // Add the instance to the realm.
            realm.add(account)
        }
        
        print("\(account)")
        dismiss(animated: true) {
            <#code#>
        }
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
