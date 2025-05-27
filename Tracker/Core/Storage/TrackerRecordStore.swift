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
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initialisers
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public methods
    
    func addNewRecord(from trackerRecord: TrackerRecord) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
        let newRecord  = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.id = trackerRecord.id
        newRecord.date = trackerRecord.date
        try! context.save()
    }
}
