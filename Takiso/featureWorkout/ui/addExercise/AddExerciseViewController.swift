//
//  AddExerciseViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
    
    @IBOutlet weak var filterButton: UIButton!
    private let viewModel = AddExerciseViewModel()
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(
            self,
            action: #selector(AddExerciseViewController.handleRefresh(_:)),
            for: .valueChanged)
        return refreshControl
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.dataSource = self
        viewModel.attachView(view: self)
        
        // Register the view cell for the table view
        exerciseTableView.register(UINib.init(
            nibName: "AddExerciseTableViewCell", bundle:nil),
                                   forCellReuseIdentifier: AddExerciseTableViewCell.REUSABLE_IDENTIFIER)
        
        // Make dynamic height for each table row
        exerciseTableView.rowHeight = UITableView.automaticDimension
        exerciseTableView.estimatedRowHeight = 400
        
        // Attach the swipe to refresh view
        exerciseTableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ sender : UIRefreshControl){
        viewModel.loadAllExercises(forcedFresh: true)
    }
    
    @IBAction func onFilterIconClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFilterScreen", sender: self)
    }
}

//MARK: - Handle AddExerciseView callback

extension AddExerciseViewController : AddExerciseView {
    func refreshExerciseList() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.exerciseTableView.reloadData()
            print("(\(self.viewModel.getTotalNumberOfFilters()))")
            self.filterButton.titleLabel?.text = "(\(self.viewModel.getTotalNumberOfFilters()))"
        }
    }
    
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.showErrorAlert(message: message)
        }
    } 
}

//MARK: - Handle Exercise Table View
extension AddExerciseViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0 { return 0 }
        else { return viewModel.getExerciseCount() }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AddExerciseTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: AddExerciseTableViewCell.REUSABLE_IDENTIFIER, for: indexPath) as! AddExerciseTableViewCell
        
        if let exercise = viewModel.getExerciseAt(position: indexPath.row) {
            cell.exerciseEntity = exercise
            cell.exerciseLabel.text = exercise.name
            var image : UIImage?
             if viewModel.isSelected(index: indexPath.row) {
                image = UIImage.init(systemName: "checkmark.circle.fill")
             } else {
                image = UIImage.init(systemName: "plus.circle")
            }
            cell.addExerciseButton.setImage(image, for: .normal)
            cell.addButtonClickFunction = {
                self.viewModel.toggleSelection(index: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.bodypartsCollectionView.reloadData()
            cell.bodypartsCollectionView.layoutSubviews()
        }
        return cell
    }
}
