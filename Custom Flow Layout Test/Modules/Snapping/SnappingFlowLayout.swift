//
//  SnappingFlowLayout.swift
//  Custom Flow Layout Test
//
//  Created by Michał Kwiecień on 07/05/2018.
//  Copyright © 2018 Kwiecien.co. All rights reserved.
//

import UIKit

class SnappingFlowLayout: UICollectionViewFlowLayout {
    
    private var firstSetupDone = false
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 20
        itemSize = CGSize(width: collectionView!.bounds.width, height: 350)
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        
        let centerOffset = collectionView!.bounds.size.height / 2
        let offsetWithCenter = proposedContentOffset.y + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.y - offsetWithCenter) < abs($1.center.y - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: 0, y: closestAttribute.center.y - centerOffset)
    }
}
