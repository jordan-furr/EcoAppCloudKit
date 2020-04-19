//
//  HabitController.swift
//  EcoAppCloudKit
//
//  Created by Jordan Furr on 4/19/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import Foundation
import CloudKit

class HabitController {
    
    //MARK: - Singleton
    static let shared = HabitController()
    
    //MARK: - Collections of all & chosen habits
    var allHabits: [Habit] = [
        Habit(title: "Refilled WaterBottle", enabled: false, counter: 0, energySaved: 0),
        Habit(title: "Recycled", enabled: false, counter: 0, energySaved: 0),
        Habit(title: "Washed laundry with cold water", enabled: false, counter: 0, energySaved: 0),
        Habit(title: "Finished food container", enabled: false, counter: 0, energySaved: 0)
    ]
    var chosenHabits: [Habit] = []
    
    
    /*
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    
    //MARK: - FETCH FUNC
    func fetchContacts(completion: @escaping (Result<[Habit], HabitError>) -> Void) {
        
        let habitPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HabitConstants.recordTypeKey, predicate: habitPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { completion(.failure(.couldNotUnwrap)); return}
            print("Successfully fetched habits")
            let habits = records.compactMap({Habit(ckRecord: $0) })
            self.allHabits = habits
            completion(.success(habits))
        }
    }
 
 */
    
    func updateSelectedHabits(){
        var selectedHabits: [Habit] = []
        for habit in allHabits {
            if habit.enabled == true {
                selectedHabits.append(habit)
            }
        }
        chosenHabits = selectedHabits
    }
}

