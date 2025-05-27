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
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    // MARK: - Initialisers
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK:  - Delegates
    
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
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }
        let categoryEntity = TrackerCategoryCoreData(entity: entity, insertInto: context)
        categoryEntity.title = category.title
        categoryEntity.trackers = NSSet(array: [])
        try! context.save()
    }
    
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        return try! context.fetch(NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData"))
    }
    
    func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategoryCoreData.title else { return nil }
        guard let trackers = trackerCategoryCoreData.trackers else { return nil }
        
        return TrackerCategory(title: title, trackers: trackers.compactMap { coreDataTracker -> Tracker? in
            if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                return trackerStore.decodingTrackers(from: coreDataTracker)
            }
            return nil
        })
    }
    
    func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        guard let trackerCoreData = trackerStore.addNewTracker(from: tracker) else { return }
        guard let existingCategory = fetchCategory(with: titleCategory) else { return }
        var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        existingTrackers.append(trackerCoreData)
        existingCategory.trackers = NSSet(array: existingTrackers)
        try! context.save()
    }
    
    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        return fetchAllCategories().filter({$0.title == title}).first ?? nil
    }
}
