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
    
    lazy var circle: CAShapeLayer = {
        let circ = CAShapeLayer()
        let center = self.center
        let uiBez = UIBezierPath.init(arcCenter: center, radius: self.frame.size.width/2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        circ.path = uiBez.cgPath
        circ.fillColor = UIColor.clear.cgColor
        circ.strokeColor = UIColor.red.cgColor
        circ.lineWidth = 5
        circ.strokeEnd = 0
        return circ
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.addSublayer(self.circle)
        self.circle.isHidden = true
        self.flagView.layer.masksToBounds = true
        self.flagView.layer.cornerRadius = self.flagView.frame.width/2
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let rotatingAttributes = layoutAttributes as! RotatingCollectionLayoutAttributes
        self.layer.anchorPoint = rotatingAttributes.anchorPoint
        self.center.y += (rotatingAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
    private func animate() {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        
        anim.toValue = 1
        anim.duration = 2
        anim.fillMode = .forwards
        
        self.circle.strokeEnd = 1
        
        self.circle.add(anim, forKey: "stroke")
    }

}
