//
//  EditTransactionViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 6.2.24..
//

import UIKit

class EditTransactionViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SettingNumberTextFieldDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SettingNumberTableViewCell.self, forCellReuseIdentifier: SettingNumberTableViewCell.identifier)
        table.register(SettingSwitchTableViewCell.self, forCellReuseIdentifier: SettingSwitchTableViewCell.identifier)
        table.backgroundColor = .white
        table.layer.cornerRadius = 12
        return table
    }()
    
    var onTransactionUpdate: ((Transaction) -> Void)?
    
    var transaction: Transaction
    
    var settingModels = [SettingsOptionType]()
    let saveButton = SaveButton()
    
    var note: String? {
        didSet {
            settingModels[1] = .staticCell(model: SettingOption(title: "Note", info: note ?? "", handler: {
                self.noteCellHandler()
            }))
            tableView.reloadData()
        }
    }
    var date: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY"
            
            settingModels[2] = .staticCell(model: SettingOption(title: "Date", info: dateFormatter.string(from: date ?? Date()), handler: {
                if #available(iOS 16.0, *) {
                    self.dateCellHandler()
                } else {
                    // Fallback on earlier versions
                }
            }))
            tableView.reloadData()
        }
    }
    var amount: Double?
    var category: TransactionCategory? {
        didSet {
            settingModels[3] = .staticCell(model: SettingOption(title: "Category", info: category?.name ?? "", handler: {
                self.categoryCellHandler()
            }))
            tableView.reloadData()
        }
    }
    
    init(transaction: Transaction) {
        self.transaction = transaction
        self.date = transaction.date
        self.amount = transaction.amount
        self.note = transaction.comment
        self.category = transaction.category
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit transaction"
        view.backgroundColor = .secondarySystemBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        navigationItemSetup()
        setSettingTable()
        setupUI()
        
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
    
    private func setupUI() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(self.settingModels.count * 44))
        ])
    }
    
    // кнопки закрыть и сохранить
    private func navigationItemSetup() {
        
        // Кнопка сохранения
        
        saveButton.saveButtonAction = { [weak self] in
            self?.saveButtonTapped()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeButtonTapped()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    private func setSettingTable() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        
        self.settingModels = [
            .numberCell(model: SettingNumberOption(title: "Amount", number: transaction.amount)),
            .staticCell(model: SettingOption(title: "Note", info: transaction.comment ?? "", handler: {
                self.noteCellHandler()
            })),
            .staticCell(model: SettingOption(title: "Date", info: dateFormatter.string(from: transaction.date), handler: {
                if #available(iOS 16.0, *) {
                    self.dateCellHandler()
                } else {
                    // Fallback on earlier versions
                }
            })),
            .staticCell(model: SettingOption(title: "Category", info: transaction.category?.name ?? "", handler: {
                self.categoryCellHandler()
            })),
        ]
        
        tableView.reloadData()
    }
    
    private func noteCellHandler() {
        let noteVC = NoteViewController()
        let navigationVC = UINavigationController(rootViewController: noteVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.large()]
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        noteVC.noteOnChange = { [weak self] note in
            self?.note = note
        }
        
        noteVC.setText(self.note)
        
        navigationController?.present(navigationVC, animated: true)
    }
    
    private func categoryCellHandler() {
        
        let transactionCategoriesVC = ChooseTransactionCategoryViewController()
        let navigationVC = UINavigationController(rootViewController: transactionCategoriesVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.large(), .custom(resolver: { context in
                    370
                })]
            } else {
                sheet.detents = [.large()]
            }
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        
        
        transactionCategoriesVC.onCategorySelect = { [weak self] category in
            self?.category = category
        }
               
        navigationController?.present(navigationVC, animated: true)
    }
    
    @available(iOS 16.0, *)
    private func dateCellHandler() {
        let calendarVC = CalendarViewController()
        let navigationVC = UINavigationController(rootViewController: calendarVC)
        
        if let sheet = navigationVC.sheetPresentationController {

            sheet.detents = [.custom(resolver: { context in
                444
            })]
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        calendarVC.onDateSelect = { [weak self] date in
            self?.date = date
        }
        calendarVC.currentDate = self.date
        navigationController?.present(navigationVC, animated: true)
    }
    
    internal func settingNumberTextFieldDidChange(_ number: Double) {
        self.amount = number
    }
    
    private func saveButtonTapped() {
        StorageManager.shared.updateTransaction(withId: transaction._id, updates: { transaction in
            transaction.amount = self.amount ?? 0.0
            transaction.category = self.category
            transaction.date = self.date ?? Date()
            transaction.comment = self.note
        })
        
        onTransactionUpdate?(transaction)
        
        dismiss(animated: true) {
            UIApplication.shared.activeWindow?.rootViewController?.view.makeToast("Transaction is updated", duration: 3.0, position: .top, style: UIApplication.shared.globalToastStyle)
        }
    }
    
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
