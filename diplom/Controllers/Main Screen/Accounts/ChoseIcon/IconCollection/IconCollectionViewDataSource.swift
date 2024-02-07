//
//  IconCollectionViewDataSource.swift
//  diplom
//
//  Created by Dulin Gleb on 18.1.24..
//

import Foundation
import UIKit

struct Icon {
    var imageName: String
    
    init(name: String) {
        self.imageName = name
    }
}

struct IconSection {
    var title: String
    var icons: [Icon]
}

protocol IconCollectionViewDelegate: AnyObject {
    func didSelectedIcon(_ icon: String)
}

class IconCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sections: [IconSection]
    
    weak var delegate: IconCollectionViewDelegate?
    
    init(sections: [IconSection]) {
        self.sections = sections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.reuseId, for: indexPath) as? IconCollectionViewCell else {
                fatalError("Cannot create cell")
            }
        
            let icon = sections[indexPath.section].icons[indexPath.row]
            cell.imageView.image = UIImage(named: icon.imageName)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 // Отступ между ячейками
        let collectionViewSize = collectionView.frame.size.width - padding * 6

        // Размер ячейки для 6 иконок в ряду
        let cellSize = CGSize(width: collectionViewSize / 6, height: collectionViewSize / 6)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iconName = sections[indexPath.section].icons[indexPath.row].imageName
        self.delegate?.didSelectedIcon(iconName)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IconHeaderCollectionReusableView.reuseId, for: indexPath) as! IconHeaderCollectionReusableView
        header.titleLabel.text = sections[indexPath.section].title
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
