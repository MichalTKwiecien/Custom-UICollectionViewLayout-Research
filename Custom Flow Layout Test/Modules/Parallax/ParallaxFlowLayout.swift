//
//  ParallaxFlowLayout.swift
//  Custom Flow Layout Test
//
//  Created by Michał Kwiecień on 07/05/2018.
//  Copyright © 2018 Kwiecien.co. All rights reserved.
//

import UIKit

class ParallaxFlowLayout: UICollectionViewLayout {
    
    private var firstSetupDone = false
    private var cache = [IndexPath: ParallaxLayoutAttributes]()
    private var visibleLayoutAttributes = [ParallaxLayoutAttributes]()
    private var contentWidth: CGFloat = 0
    
    private var itemSize = CGSize(width: 0, height: 0)
    private var maxParallaxOffset: CGFloat = 80
    
    private func setup() {
        itemSize = CGSize(width: collectionView!.bounds.width - 50, height: collectionView!.bounds.height)
    }
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
        
        cache.removeAll(keepingCapacity: true)
        cache = [IndexPath: ParallaxLayoutAttributes]()
        contentWidth = 0
        
        for section in 0 ..< collectionView!.numberOfSections {
            for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attributes = ParallaxLayoutAttributes(forCellWith: cellIndexPath)
                attributes.frame = CGRect(
                    x: contentWidth,
                    y: 0,
                    width: itemSize.width,
                    height: itemSize.height
                )
                contentWidth = attributes.frame.maxX
                cache[cellIndexPath] = attributes
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public class var layoutAttributesClass: AnyClass {
        return ParallaxLayoutAttributes.self
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: collectionView!.frame.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        let halfWidth = collectionView!.bounds.width * 0.5
        let halfCellWidth = itemSize.width * 0.5
        
        for (_, attributes) in cache {
            attributes.parallax = .identity
            if attributes.frame.intersects(rect) {
                let cellDistanceFromCenter = attributes.center.x - collectionView!.contentOffset.x - halfWidth
                let parallaxOffset = -(maxParallaxOffset * cellDistanceFromCenter) / (halfWidth + halfCellWidth)
                let boundedParallaxOffset = min(max(-maxParallaxOffset, parallaxOffset), maxParallaxOffset)
                attributes.parallax = CGAffineTransform(translationX: boundedParallaxOffset, y: 0)
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}
