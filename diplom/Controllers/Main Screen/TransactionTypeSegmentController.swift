//
//  TransactionTypeSegmentController.swift
//  diplom
//
//  Created by Dulin Gleb on 27.11.23..
//

import UIKit

class TransactionTypeSegmentController: UISegmentedControl {
    
    private let segmentInset: CGFloat = 5       //your inset amount

    override func layoutSubviews(){
        super.layoutSubviews()

        //background
        layer.cornerRadius = bounds.height/2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.backgroundColor = .white
            foregroundImageView.image = nil    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }

}
