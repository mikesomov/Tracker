//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Mike Somov on 13.05.2025.
//

import UIKit
import CoreData

// MARK: - Protocols

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerCategoryStore)
}

// MARK: - Classes

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Private properties
    
    private let context: NSManagedObjectContext = CoreDataManager.shared.context
    private let trackerStore = TrackerStore()
    
    // MARK: - Delegates
    
    weak var delegate: TrackerCategoryStoreDelegate?
}

// MARK: - Extensions

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}

extension TrackerCategoryStore {
    
    func createCategory(_ category: TrackerCategory) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else {
            assertionFailure("Failed to create entity description for TrackerCategoryCoreData")
            return
        }
        
        let categoryEntity = TrackerCategoryCoreData(entity: entity, insertInto: context)
        categoryEntity.title = category.title
        categoryEntity.trackers = NSSet(array: [])
        
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            assertionFailure("Failed to fetch TrackerCategoryCoreData: \(error.localizedDescription)")
            return []
        }
    }
    
    func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategoryCoreData.title else { return nil }

        let coreDataTrackers = (trackerCategoryCoreData.trackers?.allObjects as? [TrackerCoreData]) ?? []
        let decodedTrackers = coreDataTrackers.compactMap { trackerStore.decodingTrackers(from: $0) }

        return TrackerCategory(title: title, trackers: decodedTrackers)
    }
    
    func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        guard let trackerCoreData = trackerStore.addNewTracker(from: tracker) else {
            assertionFailure("Failed to create TrackerCoreData from Tracker")
            return
        }
        
        guard let existingCategory = fetchCategory(with: titleCategory) else {
            assertionFailure("Category with title \(titleCategory) not found")
            return
        }
        
        var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        existingTrackers.append(trackerCoreData)
        existingCategory.trackers = NSSet(array: existingTrackers)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        return fetchAllCategories().first { $0.title == title }
    }
}
