//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Mike Somov on 13.05.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    // MARK: - Private properties
    
    private let context: NSManagedObjectContext = CoreDataManager.shared.context

    // MARK: - Public methods

    func addNewRecord(from trackerRecord: TrackerRecord) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else {
            assertionFailure("Failed to create entity description for TrackerRecordCoreData")
            return
        }

        let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.id = trackerRecord.id
        newRecord.date = trackerRecord.date

        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save context: \(error.localizedDescription)")
        }
    }
}
