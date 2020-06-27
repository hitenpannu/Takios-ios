//
//  AddExerciseTableViewCell.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 17/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class AddExerciseTableViewCell: UITableViewCell {
    
    static let REUSABLE_IDENTIFIER = "exerciseItem"
    
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var bodypartsCollectionView: UICollectionView!
    
    private let collectionViewLayout = WrapperCollectionViewFlowLayout()
    var exerciseEntity: Exercise? = nil
    var addButtonClickFunction : (()-> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bodypartsCollectionView.register(UINib.init(nibName: "BodyPartViewCell", bundle: nil), forCellWithReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER)
        
        bodypartsCollectionView.dataSource = self
        bodypartsCollectionView.delegate = self
        bodypartsCollectionView.collectionViewLayout = collectionViewLayout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addButtonClickHandler(_ sender: UIButton) {
        addButtonClickFunction?()
    }
}

extension AddExerciseTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section > 0) { return 0 }
        return exerciseEntity?.bodyParts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BodyPartViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER,
                                                                         for: indexPath) as! BodyPartViewCell
        if let bodyPart = exerciseEntity?.bodyParts[indexPath.row] {
            cell.bodyPartLabel.text = bodyPart.name
        }
        
        cell.layer.borderColor = UIColor(named: "charcoal")?.cgColor.copy(alpha: 0.5)
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 4.0
        return cell
    }
}


extension AddExerciseTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelText = exerciseEntity!.bodyParts[indexPath.row].name
        let labelSize = labelText.size(withAttributes: [.font : UIFont.systemFont(ofSize: 10.0)])
        
        return CGSize(width: labelSize.width + 30.0, height: labelSize.height + 8)
    }
}
