//
//  AccountViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 2.2.24..
//

import UIKit
import RealmSwift

struct TransactionSection {
    let date: Date
    var transactions: [Transaction]
}

class AccountViewController: UIViewController, MonthPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var account: Account
    let tableView = UITableView()
    let balanceLabel = UILabel()
    let currencySymbolLabel = UILabel()
    var transactions: [Transaction] = []
    var sections: [TransactionSection] = []
    
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondarySystemBackground

        setupNavBar()
        setupUI()
        loadTransactions()
    }
    
    private func setupNavBar() {
        let titleView = UIView()
            
        let imageView = UIImageView(image: UIImage(named: self.account.iconName))
        imageView.tintColor = UIColor(hexString: account.iconColor)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = self.account.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(imageView)
        titleView.addSubview(titleLabel)
        
        // Настройка констрейнтов для imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Настройка констрейнтов для titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

        navigationItem.titleView = titleView
    }
    
    private func setupUI() {
        let balanceView = UIView()
        view.addSubview(balanceView)
        balanceView.backgroundColor = .white
        balanceView.layer.cornerRadius = 20
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        
        balanceLabel.text = getCurrentBalance()
        balanceLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        balanceLabel.textAlignment = .center
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceView.addSubview(balanceLabel)
        
        let balanceInfoLabel = UILabel()
        balanceInfoLabel.text = "Current balance"
        balanceInfoLabel.font = UIFont.systemFont(ofSize: 15)
        balanceInfoLabel.textColor = .secondaryLabel
        balanceInfoLabel.textAlignment = .center
        balanceInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceView.addSubview(balanceInfoLabel)
        
        let transactionsInfoLabel = UILabel()
        transactionsInfoLabel.text = "Transactions"
        transactionsInfoLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        transactionsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transactionsInfoLabel)
        
        let monthYearSelector = MonthYearSelector()
        monthYearSelector.translatesAutoresizingMaskIntoConstraints = false
        monthYearSelector.delegate = self
        view.addSubview(monthYearSelector)
        
        tableView.register(AccountTransactionsTableViewCell.self, forCellReuseIdentifier: AccountTransactionsTableViewCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.layer.cornerRadius = 20
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.topBarHeight + 20),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            balanceView.heightAnchor.constraint(equalToConstant: 100),
            
            balanceLabel.topAnchor.constraint(equalTo: balanceView.topAnchor, constant: 20),
            balanceLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            
            balanceInfoLabel.bottomAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: -20),
            balanceInfoLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            
            transactionsInfoLabel.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 20),
            transactionsInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            monthYearSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthYearSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monthYearSelector.topAnchor.constraint(equalTo: transactionsInfoLabel.bottomAnchor, constant: 10),
            monthYearSelector.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: monthYearSelector.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTransactionsTableViewCell.reuseId, for: indexPath) as! AccountTransactionsTableViewCell
        
        let transaction = sections[indexPath.section].transactions[indexPath.row]
        
        cell.config(
            title: transaction.category?.name ?? "Category",
            iconName: transaction.category?.iconName ?? "wallet",
            iconColor: UIColor(hexString: transaction.category?.iconColor ?? "000000"),
            amount: transaction.amount.withCommas() + " " + (transaction.account?.currency?.symbol ?? "$"),
            amountType: transaction.type
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: sections[section].date)
    }
    
    // Delete transaction
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let transaction = self.sections[indexPath.section].transactions[indexPath.row]
        
        
        if editingStyle == .delete {
            StorageManager.shared.deleteTransaction(transaction)
            tableView.beginUpdates()
            sections[indexPath.section].transactions.remove(at: indexPath.row)
            if sections[indexPath.section].transactions.isEmpty {
                sections.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            
            balanceLabel.text = getCurrentBalance()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentTransaction = self.sections[indexPath.section].transactions[indexPath.row]
        let editTransactionController = EditTransactionViewController(transaction: currentTransaction)
        let navigationVC = UINavigationController(rootViewController: editTransactionController)
        
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
        
        editTransactionController.onTransactionUpdate = { [weak self] transaction in
            guard let self = self else { return }
            self.loadTransactions()
            balanceLabel.text = getCurrentBalance()
        }
        
        
        navigationController?.present(navigationVC, animated: true)
    }
    
    private func loadTransactions(_ date: Date = Date()) {   
        transactions = Array(
            account.transactions.filter("date >= %@ AND date <= %@", date.startOfMonth, date.endOfMonth)
        )
        
        sections = []
        for transaction in transactions {
            let transactionDate = transaction.date.startOfDay
            if let sectionIndex = sections.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: transactionDate) }) {
                // Если секция для этой даты уже существует, добавьте транзакцию в нее
                sections[sectionIndex].transactions.append(transaction)
            } else {
                // Если секция для этой даты еще не существует, создайте новую
                sections.append(TransactionSection(date: transactionDate, transactions: [transaction]))
            }
        }

        sections.sort(by: { $0.date < $1.date })
        
        tableView.reloadData()
    }
    
    private func getCurrentBalance() -> String {
        return account.getCurrentBalance().withCommas() + " " + (account.currency?.symbol ?? "$")
    }

    func didPickMonthYear(date: Date) {
        loadTransactions(date)
    }
    


}
