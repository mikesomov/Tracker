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

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: trackerRecord.date)

        newRecord.id = trackerRecord.id
        newRecord.date = startOfDay

        do {
            try context.save()
        } catch {
            assertionFailure("❌ Failed to save TrackerRecord: \(error.localizedDescription)")
        }
    }
    
    func fetchRecords(for date: Date) -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )

        do {
            let results = try context.fetch(fetchRequest)
            let mapped = results.map { TrackerRecord(id: $0.id ?? UUID(), date: $0.date ?? Date()) }
            for _ in mapped {
            }
            return mapped
        } catch {
            return []
        }
    }
    
    func deleteRecord(for id: UUID, on date: Date) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(
            format: "id == %@ AND date >= %@ AND date < %@",
            id as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )

        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
            try context.save()
        } catch {
            assertionFailure("❌ Failed to delete TrackerRecord: \(error.localizedDescription)")
        }
    }
}
