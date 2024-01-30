//
//  ColorCollectionViewDataSource.swift
//  diplom
//
//  Created by Dulin Gleb on 17.1.24..
//

import Foundation
import UIKit

protocol ColorCollectionViewDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

class ColorCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var delegate: ColorCollectionViewDelegate?
    var colors: [UIColor]
    
    init(colors: [UIColor]) {
        self.colors = colors
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollorCollectionViewCell.reuseId, for: indexPath) as! CollorCollectionViewCell
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        delegate?.didSelectColor(selectedColor)
    }

}
