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
    var allHabits: [Habit] = []
    var nonChosenHabits: [Habit] = []
    var chosenHabits: [Habit] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    

    func createHabit(with title: String, enabled: Bool, counter: Int, energySaved: Double, completion: @escaping (Result<Habit?, HabitError>) -> Void){
        let newHabit = Habit(title: title, enabled: enabled, counter: counter, energySaved: energySaved)
        self.save(habit: newHabit) { (result) in
            print(result)
        }
    }
    
    func fetchHabits(completion: @escaping (Result<[Habit], HabitError>) -> Void) {
        
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
            self.updateSelectedHabits()
        }
    }
    
    func save(habit: Habit, completion: @escaping (Result<Habit?, HabitError>) -> Void){
        
        //init ckrecord from contact object
        let habitRecord = CKRecord(habit: habit)
        publicDB.save(habitRecord) { (record, error) in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            //check and unwrap ckrecord that was saved adn recreate contact object
            guard let record = record,
            let savedContact = Habit(ckRecord: record)
                else { completion(.failure(.couldNotUnwrap)); return}
            print("new contact saved")
            self.allHabits.insert(savedContact, at: 0)
            completion(.success(savedContact))
        }
    }
    
    
    func updateCounter(habit: Habit, _ completion: @escaping (Result<Habit, HabitError>) -> Void) {
        
        let record = CKRecord(habit: habit)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
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
        var all = self.allHabits
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

