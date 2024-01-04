//
//  KeyboardPadCollectionView.swift
//  diplom
//
//  Created by Dulin Gleb on 4.12.23..
//

import UIKit

protocol KeyboardPadCollectionViewDelegate: AnyObject {
    func didSelectItem(withTitle title: String)
    func didBackspace()
}

enum KeyboardButtonType {
    case digit
    case backspace
}

class KeyboardPadCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var keyboardPadCollectionViewDelegate: KeyboardPadCollectionViewDelegate?
    
    private let reuseIdentifier = "Cell"
    
    let numbers: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "del"
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numbers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! KeyboardPadCollectionViewCell
    
        switch numbers[indexPath.row] {
            case "del":
                cell.configure(withImage: UIImage(named: "backspace"))
                cell.keyboardButtonType = .backspace
            default:
                cell.configure(withText: numbers[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? KeyboardPadCollectionViewCell
        let selectedTitle = cell?.textLabel.text
        
        if cell?.keyboardButtonType == .digit {
            keyboardPadCollectionViewDelegate?.didSelectItem(withTitle: selectedTitle ?? "")
        } else if cell? .keyboardButtonType == .backspace {
            keyboardPadCollectionViewDelegate?.didBackspace()
        }
        
    }
}

extension KeyboardPadCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let collectionViewWidth = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        let width: CGFloat = adjustedWidth / columns
        let height: CGFloat = (collectionView.bounds.height / 3) - (flowLayout.minimumLineSpacing * 3)
        return CGSize(width: width, height: height)
    }
}
