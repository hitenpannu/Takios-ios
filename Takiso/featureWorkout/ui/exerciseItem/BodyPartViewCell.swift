//
//  BodyPartViewCell.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 17/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class BodyPartViewCell: UICollectionViewCell {

    static let REUSABLE_IDENTIFIER = "bodyPartCell"
    
    @IBOutlet weak var bodyPartLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
