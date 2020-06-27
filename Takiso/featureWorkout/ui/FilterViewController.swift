//
//  FilterViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 27/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var bodyPartsCollectionView: UICollectionView!
    @IBOutlet weak var equipmentsCollectionView: UICollectionView!
    
    private let viewModel = FilterViewModel()
    private let equipmentsCollectionViewLayout = WrapperCollectionViewFlowLayout()
    private let bodyPartsCollectionViewLayout = WrapperCollectionViewFlowLayout()
    
    override func viewDidLoad() {
        initializeCollectionViews()
        viewModel.attachView(view: self)
        viewModel.loadAvailableFilters()
        
        bodyPartsCollectionView.dataSource = self
        equipmentsCollectionView.dataSource = self
        
        bodyPartsCollectionView.delegate = self
        equipmentsCollectionView.delegate = self
    }
    
    private func initializeCollectionViews() {
        bodyPartsCollectionView.register(UINib.init(nibName: "BodyPartViewCell", bundle: nil), forCellWithReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER)
        
        bodyPartsCollectionView.collectionViewLayout = bodyPartsCollectionViewLayout
        
        equipmentsCollectionView.register(UINib.init(nibName: "BodyPartViewCell", bundle: nil), forCellWithReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER)
        
        equipmentsCollectionView.collectionViewLayout = equipmentsCollectionViewLayout
    }
    
    @IBAction func applyFilterButtonClickHandler(_ sender: UIButton) {
        
    }
}

extension FilterViewController : FilterView {
 
    func updateBodyParts() {
        DispatchQueue.main.async {
            self.bodyPartsCollectionView.reloadData()
        }
    }
    
    func updateEquipments() {
     DispatchQueue.main.async {
            self.equipmentsCollectionView.reloadData()
        }
    }
}

extension FilterViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bodyPartsCollectionView {
            return viewModel.totalNumberOfBodyParts()
        } else if collectionView ==  equipmentsCollectionView {
            return viewModel.totalNumberOfEquipments()
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : BodyPartViewCell
        var isSelected : Bool = false
        if collectionView == bodyPartsCollectionView {
            let bodyPart = viewModel.getBodyPart(at: indexPath.row)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER, for: indexPath) as! BodyPartViewCell
            cell.bodyPartLabel.text = bodyPart.name
            isSelected = viewModel.isSelected(bodyPart: bodyPart)
            
        } else if collectionView ==  equipmentsCollectionView {
            let equipment = viewModel.getEquipment(at: indexPath.row)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyPartViewCell.REUSABLE_IDENTIFIER, for: indexPath)  as! BodyPartViewCell
            cell.bodyPartLabel.text = equipment.name
            isSelected = viewModel.isSelected(equipment: equipment)
        } else {
            fatalError("Un supported Cell")
        }

        // Set the border for the cell items
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 4.0
        cell.bodyPartLabel.font = cell.bodyPartLabel.font.withSize(12.0)
        cell.bodyPartLabel.alpha = 1.0
        
        cell.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.8)
        
        if isSelected {
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.bodyPartLabel.textColor = UIColor.init(named: "maizeCrayola")
        } else {
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.bodyPartLabel.textColor = UIColor.white
        }
        return cell
    }
}

extension FilterViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var textToSet = ""
        if collectionView == bodyPartsCollectionView {
            textToSet = viewModel.getBodyPart(at: indexPath.row).name
        }else if collectionView == equipmentsCollectionView {
            textToSet = viewModel.getEquipment(at: indexPath.row).name
        }
        let labelSize = textToSet.size(withAttributes: [.font : UIFont.systemFont(ofSize: 12.0)])
        return CGSize(width: labelSize.width + 30.0, height: labelSize.height + 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bodyPartsCollectionView {
            viewModel.toggleBodyPart(index: indexPath.row)
        } else if collectionView == equipmentsCollectionView {
            viewModel.toggleEquipment(index: indexPath.row)
        }
        collectionView.reloadData()
    }
}
