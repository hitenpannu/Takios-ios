//
//  CardView.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: DesignableView {
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var contentPadding : CGFloat = 0 {
        didSet {
            bounds = frame.insetBy(dx: contentPadding, dy: contentPadding)
        }
    }
}
