//
//  DynamicHeightCollectionView.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 17/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
