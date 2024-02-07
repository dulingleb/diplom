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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        
        setupCollectionView()
        
        accounts = Array(StorageManager.shared.getAccounts())
        collectionView.reloadData()
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

}
