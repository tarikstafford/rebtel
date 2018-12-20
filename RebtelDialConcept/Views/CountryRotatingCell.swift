//
//  CountryRotatingCell.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 19/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class CountryRotatingCell: UICollectionViewCell {

    @IBOutlet weak var flagView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height/2
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let rotatingAttributes = layoutAttributes as! RotatingCollectionLayoutAttributes
        self.layer.anchorPoint = rotatingAttributes.anchorPoint
        self.center.y += (rotatingAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }

}
