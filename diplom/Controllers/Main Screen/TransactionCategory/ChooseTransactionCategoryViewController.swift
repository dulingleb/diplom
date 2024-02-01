//
//  ChooseTransactionCategoryViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 30.1.24..
//

import UIKit
import RealmSwift

class ChooseTransactionCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    var transactionCategories: Results<TransactionCategory>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Category"
        view.backgroundColor = .secondarySystemBackground

        setupCollectionView()
        loadTransactionCategories()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.size.width - 16) / 3 // Предполагаем 8 точек отступа между ячейками
            layout.itemSize = CGSize(width: width, height: 68)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 62).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func loadTransactionCategories() {
        let realm = try! Realm()
        transactionCategories = realm.objects(TransactionCategory.self)
        collectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let item = transactionCategories[indexPath.item]
        
        cell.imageView?.image = UIImage(named: <#T##String#>)
        
        return cell
    }

}
