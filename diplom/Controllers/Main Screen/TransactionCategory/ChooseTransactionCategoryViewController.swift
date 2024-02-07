//
//  ChooseTransactionCategoryViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 30.1.24..
//

import UIKit
import RealmSwift
import Toast

struct ContextMenuItem {
    var title: String = ""
    var image: UIImage?
    var handler: ((IndexPath) -> Void)?
}

class ChooseTransactionCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var transactionCategories: [TransactionCategory]?
    var transaction: Transaction!
    
    var contextMenuItems: [ContextMenuItem] = []
    
    var onCategorySelect: ((TransactionCategory) -> Void)?
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
        
        title = "Choose Category"
        view.backgroundColor = .secondarySystemBackground
        
       contextMenuItems = [
            ContextMenuItem(title: "Remove", image: UIImage(named: "delete") ?? nil, handler: { indexPath in
                self.removeCell(indexPath)
            })
        ]

        setupCollectionView()
        loadTransactionCategories()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TransactionCategoryCollectionViewCell.self, forCellWithReuseIdentifier: TransactionCategoryCollectionViewCell.reuseID)
        
        collectionView.backgroundColor = view.backgroundColor
        
        view.addSubview(collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.size.width - 52) / 3 // Предполагаем 8 точек отступа между ячейками
            layout.itemSize = CGSize(width: width, height: 68)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 62).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func loadTransactionCategories() {
        transactionCategories = Array(StorageManager.shared.getTransactionCategories(type: self.type))
        collectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (transactionCategories?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCategoryCollectionViewCell.reuseID, for: indexPath) as! TransactionCategoryCollectionViewCell
        
        if indexPath.row == 0 {
            cell.config(title: "Add New", iconName: "add.circle", iconColor: .systemBlue, textColor: .systemBlue)
            return cell
        }
        
        let item = transactionCategories?[indexPath.item - 1]
        
        if let item = item {
            cell.config(title: item.name, iconName: item.iconName, iconColor: UIColor(hexString: item.iconColor))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let createCategoryVC = CreateTransactionCategoryViewController(type: self.type)
            let navigationVC = UINavigationController(rootViewController: createCategoryVC)
            
            if let sheet = navigationVC.sheetPresentationController {
                sheet.detents = [.large()]
                
                navigationVC.sheetPresentationController?.preferredCornerRadius = 30
            }
            
            createCategoryVC.typeOfCategory = .expense
            createCategoryVC.categoryCallback = { [weak self] category in
                self?.transactionCategories?.append(category)
                self?.collectionView.reloadData()
            }
            
            navigationController?.present(navigationVC, animated: true)
        } else {

            self.onCategorySelect?(transactionCategories![indexPath.item - 1])
            
            dismiss(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row == 0 { return nil }
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
        guard let itemToDelete = self.transactionCategories?[indexPath.row - 1] else { return }

        if StorageManager.shared.getTransactionCategories().filter("type = %@", self.type.rawValue).isEmpty {
            showAlert(title: "Warning!", message: "You can't remove the last category")
            return
        }
        
        showConfirmationAlert(title: "Warning!", message: "If you remove this category You will lost all transactions of the \(itemToDelete.name) category") {

            StorageManager.shared.deleteTransactionCategory(itemToDelete)
            
            self.transactionCategories?.remove(at: indexPath.row - 1)
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
        
        
    }

}
