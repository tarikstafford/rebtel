//
//  RotatingCollectionFlow.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 19/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class RotatingCollectionLayout: UICollectionViewLayout {
    
    var layoutAttributes = [RotatingCollectionLayoutAttributes]()
    
    // Init with Gap and ItemSize
    let gap: CGFloat
    
    let itemSize: CGSize
    
    init(gap: CGFloat, itemSize: CGSize) {
        self.gap = gap
        self.itemSize = itemSize
        self.radius = CGFloat(255.0/(2.0 * .pi)) * (itemSize.width + gap)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Angle for items in CV & for attributes
    var angleAtEnd: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * angleProvided : 0
    }
    
    var angle: CGFloat {
        return angleAtEnd * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    var angleProvided: CGFloat {
        get{
            return tan((itemSize.width + 5)/radius)
        }
    }
    
    var radius: CGFloat {
        didSet{
            invalidateLayout()
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get{
            return CGSize.init(width: (CGFloat(collectionView!.numberOfItems(inSection: 0)) * (itemSize.width + gap)), height: collectionView!.bounds.height)
        }
    }
    
    override class var layoutAttributesClass: AnyClass {
        get {
            return RotatingCollectionLayoutAttributes.self
        }
    }
    
    // Called each time you scroll the ScrollView to readjust values in Layout Attributes
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let theta = atan2(((collectionView.bounds.width) / 2.0), (radius + (itemSize.height / 2.0) - (collectionView.bounds.height) / 2.0))
        var startIndex = 0
        var endIndex = collectionView.numberOfItems(inSection: 0) - 1

        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle) / angleProvided))
        }
        
        endIndex = min(endIndex, Int(ceil((theta - angle) / angleProvided)))

        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        let anchorPointY = (radius - itemSize.height/2)/itemSize.height
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        layoutAttributes = (startIndex...endIndex).map({
            let attributes = RotatingCollectionLayoutAttributes(forCellWith: IndexPath.init(row: $0, section: 0))
            attributes.size = self.itemSize
            attributes.center = CGPoint.init(x: centerX, y: collectionView.bounds.midY)
            attributes.angle = self.angle + (self.angleProvided * CGFloat($0))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        })
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension RotatingCollectionLayout {
    // MARK: To Do - Add Snapping and adjustment of rotating by multiples of theta - this should give a rotation motation fixed on item centers?
//    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
//        <#code#>
//    }
    
    override func invalidateLayout() {
        self.layoutAttributes.removeAll()
        super.invalidateLayout()
    }
}

class RotatingCollectionLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet{
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform.init(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let attributes: RotatingCollectionLayoutAttributes = super.copy(with: zone) as! RotatingCollectionLayoutAttributes
        attributes.anchorPoint = self.anchorPoint
        attributes.angle = self.angle
        return attributes
    }
    
}
