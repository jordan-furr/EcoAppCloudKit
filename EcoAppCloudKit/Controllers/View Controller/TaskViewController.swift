//
//  TaskViewController.swift
//  EcoAppCloudKit
//
//  Created by Jordan Furr on 4/19/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
        
    
    var habit: Habit?
    
    //MARK: - IB Outlets
    @IBOutlet weak var counterLabel: UILabel!
    
    

    @IBAction func forgetTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Forget Habit?", message: "You will be able to add this habit back later", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        
        let defaultAction = UIAlertAction(title: "Forget", style: .default) { (error) in
            do {
                self.navigationController?.popViewController(animated: true)
            }
            catch let error as NSError {
                print ("Error forgeting habit", error)
            }
        }
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Helpers
    func updateViews(){
        guard let habit = habit else {return}
        self.title = habit.title
        counterLabel.text = "Successfully completed:            x   \(habit.counter ?? 0)"
    }

}
