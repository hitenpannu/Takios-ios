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
    
    private let viewModel = AddExerciseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.dataSource = self
        viewModel.attachView(view: self)
    }
}

//MARK: - Handle AddExerciseView callback

extension AddExerciseViewController : AddExerciseView {
    func refreshExerciseList() {
        DispatchQueue.main.async {
            self.exerciseTableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseItem", for: indexPath)
        cell.textLabel?.text = viewModel.getExerciseAt(position: indexPath.row)?.name
        return cell
    }
}
