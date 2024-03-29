//
//  ListAccountsTableViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 5.1.24..
//

import UIKit
import RealmSwift

class ListAccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    var accounts: [Account] = [] {
        didSet{
            guard let tableView = tableView else { return }
            
            let tableHeight = CGFloat((accounts.count + 1) * 44)
            
            tableView.frame = CGRect(
                x: 16,
                y: navigationController?.navigationBar.frame.height ?? 0,
                width: view.bounds.width - 32,
                height: self.view.frame.size.height > tableHeight ? tableHeight : self.view.frame.size.height - (navigationController?.navigationBar.frame.size.height ?? 0) - 50
            )
        }
    }
    
    var onAccountSelect: ((Account) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView = UITableView(frame: .zero)
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.layer.cornerRadius = 12
        
        view.addSubview(tableView)
        
        tableView.register(AccountListTableViewCell.self, forCellReuseIdentifier: AccountListTableViewCell.reuseId)
        
        view.backgroundColor = .secondarySystemBackground
        
        title = "Choose Account"
        
        accounts = Array(StorageManager.shared.getAccounts())
        
        navigationItemSetup()
    }
    
    private func navigationItemSetup() {
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeTapped()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accounts.count + 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountListTableViewCell.reuseId, for: indexPath) as! AccountListTableViewCell
        
        if indexPath.row < accounts.count {
            cell.iconImageView.image = UIImage(named: accounts[indexPath.row].iconName)
            cell.iconImageView.tintColor = UIColor(hexString: accounts[indexPath.row].iconColor)
            cell.titleLabel.text = accounts[indexPath.row].name
            cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 16)
        } else {
            cell.iconImageView.image = UIImage(systemName: "plus.circle")
            cell.titleLabel.text = "Create new"
            cell.titleLabel.textColor = .tintColor
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < accounts.count {
            onAccountSelect?(accounts[indexPath.row])
            dismiss(animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let createAccountVC = CreateAccountViewController()
            let navigationVC = UINavigationController(rootViewController: createAccountVC)
            
            if let sheet = navigationVC.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheet.detents = [.large()]
                } else {
                    // Fallback on earlier versions
                }
                
                navigationVC.sheetPresentationController?.preferredCornerRadius = 30
            }
            createAccountVC.accountCallback = { [weak self] account in
                self?.accounts.append(account)
                self?.tableView.reloadData()
            }
            
            navigationController?.present(navigationVC, animated: true)
        }
    }
    
    

    @objc func closeTapped() {
        dismiss(animated: true)
    }

}
