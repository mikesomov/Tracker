//
//  TrackerStore.swift
//  Tracker
//
//  Created by Mike Somov on 13.05.2025.
//

import UIKit
import CoreData

final class TrackerStore {
    
    // MARK: - Private properties
    
    private let context: NSManagedObjectContext = CoreDataManager.shared.context

    // MARK: - Public methods

    func addNewTracker(from tracker: Tracker) -> TrackerCoreData? {
        guard let trackerCoreData = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else { return nil }
        let newTracker = TrackerCoreData(entity: trackerCoreData, insertInto: context)
        newTracker.id = tracker.id
        newTracker.title = tracker.title
        newTracker.color = UIColorMarshalling.hexString(from: tracker.color)
        newTracker.emoji = tracker.emoji
        newTracker.schedule = tracker.schedule as NSArray?
        print("Added Tracker to Core Data: \(tracker.title)")
        return newTracker
    }

    func fetchTracker() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            let trackers = trackerCoreDataArray.map { trackerCoreData in
                print("Fetched Tracker: \(trackerCoreData.title ?? "")")
                return Tracker(
                    id: trackerCoreData.id ?? UUID(),
                    title: trackerCoreData.title ?? "",
                    color: UIColorMarshalling.color(from: trackerCoreData.color ?? ""),
                    emoji: trackerCoreData.emoji ?? "",
                    schedule: []
                )
            }
            return trackers
        } catch {
            assertionFailure("Failed to fetch TrackerCoreData: \(error.localizedDescription)")
            return []
        }
    }

    func decodingTrackers(from trackersCoreData: TrackerCoreData) -> Tracker? {
        guard
            let id = trackersCoreData.id,
            let title = trackersCoreData.title,
            let colorHex = trackersCoreData.color,
            let emoji = trackersCoreData.emoji,
            let schedule = trackersCoreData.schedule as? [Int]
        else {
            return nil
        }

        let color = UIColorMarshalling.color(from: colorHex)
        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
    }
}
