//
//  Habit.swift
//  EcoAppCloudKit
//
//  Created by Jordan Furr on 4/19/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import Foundation
import CloudKit

struct HabitConstants {
    static let titleKey = "title"
    static let counterKey = "counter"
    static let energySavedKey = "energySaved"
    static let recordTypeKey = "Habit"
    static let enabledKey = "enabled"
}

class Habit {
    
    var title: String
    var enabled: Bool
    var counter: Int?
    var energySaved: Double?
    let ckRecordID: CKRecord.ID
    
    init(title: String, enabled: Bool, counter: Int, energySaved: Double, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.enabled = enabled
        self.counter = counter
        self.energySaved = energySaved
        self.ckRecordID = ckRecordID
    }
}

extension CKRecord {
    
    convenience init(habit: Habit) {
        self.init(recordType: HabitConstants.recordTypeKey, recordID: habit.ckRecordID)
        self.setValuesForKeys ([
            HabitConstants.titleKey : habit.title,
            HabitConstants.enabledKey : habit.enabled,
            HabitConstants.counterKey : habit.counter ?? 0,
            HabitConstants.energySavedKey : habit.energySaved ?? 0.0
        ])
    }
}

extension Habit {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[HabitConstants.titleKey] as? String,
            let enabled = ckRecord[HabitConstants.enabledKey] as? Bool,
            let counter = ckRecord[HabitConstants.counterKey] as? Int,
            let energySaved = ckRecord[HabitConstants.energySavedKey] as? Double
            else {return nil}
        
        self.init(title: title, enabled: enabled, counter: counter, energySaved: energySaved)
    }
}

extension Habit: Equatable {
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
