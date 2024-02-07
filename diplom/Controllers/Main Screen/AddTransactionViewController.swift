//
//  MainViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 27.11.23..
//

import UIKit
import RealmSwift

class AddTransactionViewController: UIViewController, KeyboardPadCollectionViewDelegate {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var choseAccountButton: ChoseAccountButton!
    @IBOutlet weak var choseIncomeCattegoryButton: ChoseAccountButton!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var accountButtonsView: UIStackView!
    
    @IBOutlet weak var keboardCollectionView: KeyboardPadCollectionView!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var amount: Double = 0
    var amountString: String = "0" {
        didSet {
            self.amount = Double(amountString.replacingOccurrences(of: ",", with: "")) ?? 0
            if self.amount > 999999999.99 {
                amountString = oldValue
                self.amount = Double(oldValue.replacingOccurrences(of: ",", with: "")) ?? 0
            }
            
            if self.amount == 0 {
                amountLabel.textColor = .opaqueSeparator
                commentButton.isEnabled = false
                commentButton.imageView?.alpha = 0.4
                calendarButton.isEnabled = false
                calendarButton.imageView?.alpha = 0.4
                addTransactionButton.isEnabled = false
            } else {
                amountLabel.textColor = .black
                commentButton.isEnabled = true
                commentButton.imageView?.alpha = 1
                calendarButton.isEnabled = true
                calendarButton.imageView?.alpha = 1
                addTransactionButton.isEnabled = true
            }
            
            amountString = amountString.insertCommas()
            
            amountLabel.text = amountPrefix + amountString
        }
    }
    var date: Date = Date()
    var note: String?
    var transactionType: TransactionType = .expense
    
    var amountPrefix: String = "$"
    var account: Account? {
        didSet {
            choseAccountButton.setTitle(account?.name, for: .normal)
            
            let iconForAccount: UIImage = UIImage(named: account?.iconName ?? "wallet")!
            choseAccountButton.setLeftImage(leftImage: iconForAccount, tintColor: UIColor(hexString: account?.iconColor ?? "000000"))

            amountPrefix = account?.currency?.symbol ?? "$"
        }
    }
    
    var incomeCategory: TransactionCategory? {
        didSet {
            let incomCategoyIcon: UIImage = UIImage(named: incomeCategory?.iconName ?? "briefcase")!
            choseIncomeCattegoryButton.setLeftImage(leftImage: incomCategoyIcon, tintColor: UIColor(hexString: incomeCategory?.iconColor ?? "000000"))
            
            choseIncomeCattegoryButton.setTitle(incomeCategory?.name, for: .normal)
        }
    }
    
    var expenseCategory: TransactionCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.set(false, forKey: "DataInitialized")
        DataInitializer.initializeDataIfNeeded()
        print("User Realm User file location: \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        keboardCollectionView.keyboardPadCollectionViewDelegate = self
        setupUI()
    }
    
    private func setupUI() {
        account = StorageManager.shared.getAccounts().first
        
        choseAccountButton.setRightArrow()
        
        incomeCategory = StorageManager.shared.getTransactionCategories(type: .income).first
        choseIncomeCattegoryButton.setRightArrow(false)
        
        accountButtonsView.axis = .vertical
        accountButtonsView.alignment = .center
        accountButtonsView.distribution = .fill
        
        commentButton.imageView?.alpha = 0.5
        calendarButton.imageView?.alpha = 0.5
    }
    
    @IBAction func typeTransactionSegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            choseIncomeCattegoryButton.isHidden = true
            arrowImage.isHidden = true
            
            accountButtonsView.axis = .vertical
            
            choseAccountButton.setRightArrow()
            choseAccountButton.setButtonWidth(nil)
            choseAccountButton.setTitle(account?.name, for: .normal)
            
            transactionType = .expense
        } else {
            choseIncomeCattegoryButton.isHidden = false
            
            arrowImage.isHidden = false
            arrowImage.contentMode = .scaleAspectFit
            
            choseIncomeCattegoryButton.widthAnchor.constraint(equalTo: choseAccountButton.widthAnchor).isActive = true
            
            accountButtonsView.axis = .horizontal
            accountButtonsView.spacing = 8
            
            choseAccountButton.setRightArrow(false)
            let buttonWidth = (accountButtonsView.frame.width - 16 - arrowImage.frame.width)/2
            choseAccountButton.setButtonWidth(buttonWidth)
            choseAccountButton.setTitle(account?.name, for: .normal)
            
            transactionType = .income
        }
    }
    
    @IBAction func addTransactionButtonClick(_ sender: Any) {
        if amount == 0 || amount > 999999999.99 {
            print("error amount: \(amount)")
            return
        }
        
        if self.transactionType == .expense {
            self.addTransactionExpense()
        } else {
            self.storeTransaction(type: .income, category: incomeCategory!)
            UIApplication.shared.activeWindow?.rootViewController?.view.makeToast("Transaction is added", duration: 3.0, position: .top, style: UIApplication.shared.globalToastStyle)
            self.clear()
        }
    }
    
    @available(iOS 16.0, *)
    @IBAction func calendarButtonClick(_ sender: Any) {
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
            
            let calendar = Calendar.current
            if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
                self?.calendarButton.tintColor = .systemBlue
            } else {
                self?.calendarButton.tintColor = .black
            }
        }
        calendarVC.currentDate = self.date
        navigationController?.present(navigationVC, animated: true)
    }
    
    @IBAction func noteButtonClick(_ sender: Any) {
        let noteVC = NoteViewController()
        let navigationVC = UINavigationController(rootViewController: noteVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.large()]
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        noteVC.noteOnChange = { [weak self] note in
            self?.note = note
            
            if note == nil || note?.count == 0 {
                self?.commentButton.tintColor = .black
            } else {
                self?.commentButton.tintColor = .systemBlue
            }
        }
        
        noteVC.setText(self.note)
        
        navigationController?.present(navigationVC, animated: true)
    }
    
    
    @IBAction func choseAccountButtonClick(_ sender: Any) {
        let accountsVC = ListAccountsViewController()
        let navigationVC = UINavigationController(rootViewController: accountsVC)
        
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
        
        accountsVC.onAccountSelect = { [weak self] account in
            self?.account = account
        }
        
        navigationController?.present(navigationVC, animated: true)
    }
    
    @IBAction func chooseIncomeCategoryButtonClick(_ sender: Any) {
        let transactionCategoriesVC = ChooseTransactionCategoryViewController(type: .income)
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
            self?.incomeCategory = category
        }
               
        navigationController?.present(navigationVC, animated: true)
    }
    
    
    private func addTransactionExpense() {
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
            self?.storeTransaction(type: .expense, category: category)
            
            UIApplication.shared.activeWindow?.rootViewController?.view.makeToast("Transaction is added", duration: 3.0, position: .top, style: UIApplication.shared.globalToastStyle)
            
            self?.clear()
        }
               
        navigationController?.present(navigationVC, animated: true)
    }
    
    private func storeTransaction(type: TransactionType, category: TransactionCategory) {
        let transaction = Transaction()
        transaction.amount = self.amount
        transaction.account = self.account
        transaction.date = self.date
        transaction.comment = self.note
        transaction.category = category
        transaction.type = type.rawValue
        
        StorageManager.shared.addTransaction(transaction)
    }
    
    private func clear() {
        self.amountString = "0"
        self.note = nil
        self.date = Date()
        
    }
    
    func didPressNumberButton(withTitle title: String) {
        if title == "." && amountString.contains(".") {return}
        
        if !amountString.hasValidDecimalPlaces() {return}
        
        if title != "." && !amountString.contains(".") {
            amountString = amountString.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }        
        
        amountString += title
    }
    
    func didPressBackspace() {
        if amountString.count > 1 {
            amountString.removeLast()
        } else {
            amountString = "0"
        }
    }
    
    
    
}
