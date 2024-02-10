//
//  AccountsViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 1.2.24..
//

import UIKit
import RealmSwift

class AccountsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var accounts: [Account] = []
    var contextMenuItems: [ContextMenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        
        setupContextMenu()
        setupCollectionView()
        
        accounts = Array(StorageManager.shared.getAccounts())
        collectionView.reloadData()
    }
    
    private func setupContextMenu() {
        contextMenuItems = [
             ContextMenuItem(title: "Remove", image: UIImage(named: "delete") ?? nil, handler: { indexPath in
                 self.removeCell(indexPath)
             }),
             ContextMenuItem(title: "Edit", image: UIImage(named: "edit") ?? nil, handler: { indexPath in
                 self.openEditAccount(editAccount: self.accounts[indexPath.row])
             })
         ]
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AccountsCollectionViewCell.self, forCellWithReuseIdentifier: AccountsCollectionViewCell.reuseId)
        
        collectionView.backgroundColor = view.backgroundColor
        
        view.addSubview(collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.width
            layout.itemSize = CGSize(width: width - 40, height: 110)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 62).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accounts = Array(StorageManager.shared.getAccounts())
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountsCollectionViewCell.reuseId, for: indexPath) as! AccountsCollectionViewCell
        
        let item = accounts[indexPath.item]

        cell.config(
            name: item.name,
            amount: item.getCurrentBalance().withCommas(),
            symbol: item.currency?.symbol ?? "$",
            icon: item.iconName,
            iconColor: UIColor(hexString: item.iconColor)
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let accountVC = AccountViewController(account: accounts[indexPath.item])
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        })
    }
    
    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        var actions = [UIAction]()
        for item in self.contextMenuItems {
            let action = UIAction(title: item.title, image: item.image, identifier: nil, discoverabilityTitle: nil) { _ in
                item.handler?(indexPath)
            }
            actions.append(action)
        }
        let cancel = UIAction(title: "Cancel", attributes: .destructive) { _ in}
        actions.append(cancel)
        return UIMenu(title: "", children: actions)
    }
    
    private func removeCell(_ indexPath: IndexPath) {
        let itemToDelete = self.accounts[indexPath.row]

        if StorageManager.shared.getAccounts().count == 1 {
            showAlert(title: "Warning!", message: "You can't remove the last account")
            return
        }
        
        showConfirmationAlert(title: "Warning!", message: "If you remove this account You will lost all transactions of the \(itemToDelete.name) account") {

            StorageManager.shared.deleteAccount(itemToDelete)
            
            self.accounts.remove(at: indexPath.row)
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
        
        
    }
    
    private func openEditAccount(editAccount: Account) {
        let createAccountVC = CreateAccountViewController(account: editAccount)
        let navigationVC = UINavigationController(rootViewController: createAccountVC)
        
        if #available(iOS 16.0, *) {
            if let sheet = navigationVC.sheetPresentationController {
                    sheet.detents = [.large()]
                navigationVC.sheetPresentationController?.preferredCornerRadius = 30
            }
        } else {
            
        }
        
        createAccountVC.accountCallback = { [weak self] account in
            self?.collectionView.reloadData()
        }
        
        navigationController?.present(navigationVC, animated: true)
    }
    

}
