//
//  WrapperCollectionViewFlowLayout.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 18/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class WrapperCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let cellSpacing:CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
               self.minimumLineSpacing = 4.0
               self.sectionInset = UIEdgeInsets(top: 4, left:0, bottom: 4, right: 6)
               let attributes = super.layoutAttributesForElements(in: rect)

               var leftMargin = sectionInset.left
               var maxY: CGFloat = -1.0
               attributes?.forEach { layoutAttribute in
                   if layoutAttribute.frame.origin.y >= maxY {
                       leftMargin = sectionInset.left
                   }
                   layoutAttribute.frame.origin.x = leftMargin
                   leftMargin += layoutAttribute.frame.width + cellSpacing
                   maxY = max(layoutAttribute.frame.maxY , maxY)
               }
               return attributes
       }
}
