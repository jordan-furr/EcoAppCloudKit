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
        Habit(title: "Finished food container", enabled: false, counter: 0, energySaved: 0),
        Habit(title: "Picked up trash", enabled: true, counter: 0, energySaved: 0)
    ]
    var nonChosenHabits: [Habit] = []
    var chosenHabits: [Habit] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    /*
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
    
    func updateCounter(habit: Habit, _ completion: @escaping (Result<Habit, HabitError>) -> Void) {
        
        let record = CKRecord(habit: habit)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
            let habit = Habit(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            print(("Updated \(record.recordID.recordName) successfully in CloudKit"))
            completion(.success(habit))
        }
        publicDB.add(operation)
    }
    
    func updateSelectedHabits(){
        var selectedHabits: [Habit] = []
        var unselectedHabits: [Habit] = []
        for habit in allHabits {
            if habit.enabled == true {
                selectedHabits.append(habit)
            } else {
                unselectedHabits.append(habit)
            }
        }
        chosenHabits = selectedHabits
        nonChosenHabits = unselectedHabits
    }
}

