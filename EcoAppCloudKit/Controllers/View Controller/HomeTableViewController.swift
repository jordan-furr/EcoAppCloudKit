//
//  HomeTableViewController.swift
//  EcoAppCloudKit
//
//  Created by Jordan Furr on 4/19/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        HabitController.shared.updateSelectedHabits()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitController.shared.chosenHabits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? HabitTableViewCell else {return UITableViewCell()}
        let habit = HabitController.shared.chosenHabits[indexPath.row]
        cell.setHabit(habit: habit)
        cell.delegate = self
        return cell
    }
     
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? TaskViewController else {return}
            let habit = HabitController.shared.chosenHabits[indexPath.row]
            destinationVC.habit = habit
        }
    }
}

extension HomeTableViewController: HabitTableViewCellDelegate {
    func tappedButton(for cell: HabitTableViewCell) {
        guard let habit = cell.habit else {return}
        habit.counter = habit.counter! + 1
        cell.updateUI()
        HabitController.shared.updateCounter(habit: habit) { ( result) in
            print("counter update saved")
        }
    }
}

