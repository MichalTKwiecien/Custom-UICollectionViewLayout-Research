//
//  ParallaxLayoutAttributes.swift
//  Custom Flow Layout Test
//
//  Created by Michał Kwiecień on 07/05/2018.
//  Copyright © 2018 Kwiecien.co. All rights reserved.
//

import UIKit

class ParallaxLayoutAttributes: UICollectionViewLayoutAttributes {

    var parallax: CGAffineTransform = .identity
    
    override func copy(with zone: NSZone?) -> Any {
        guard let attributes = super.copy(with: zone) as? ParallaxLayoutAttributes else { return super.copy(with: zone) }
        attributes.parallax = parallax
        return attributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? ParallaxLayoutAttributes else { return false }
        guard NSValue(cgAffineTransform: attributes.parallax) == NSValue(cgAffineTransform: parallax) else { return false }
        return super.isEqual(object)
    }
}
