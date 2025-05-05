//
//  TrackerStorage.swift
//  Tracker
//
//  Created by Mike Somov on 17.04.2025.
//

import UIKit

final class TrackerStorage {
    
    // MARK: - Public properties
    
    static let shared = TrackerStorage()
    var visibleCategory: [TrackerCategory] = []
    var categories: [TrackerCategory] = [TrackerCategory(title: .badHabits, tracker: [])]
    
    // MARK: - Initialisers
    
    private init() {}
    
    // MARK: Public methods
    
    func addTrackerToVisibleTrackers(weekday: Int) {
        var weekdayCase: Weekday = .monday
        
        switch weekday {
        case 1:
            weekdayCase = .sunday
        case 2:
            weekdayCase = .monday
        case 3:
            weekdayCase = .tuesday
        case 4:
            weekdayCase = .wednesday
        case 5:
            weekdayCase = .thursday
        case 6:
            weekdayCase = .friday
        case 7:
            weekdayCase = .saturday
        default:
            break
        }
        
        var trackers = [Tracker]()
        
        for tracker in categories.first!.tracker {
            for day in tracker.schedule {
                if day == weekdayCase {
                    trackers.append(tracker)
                }
            }
        }
        
        let category = TrackerCategory(title: .badHabits, tracker: trackers)
        visibleCategory.append(category)
    }
    
    func removeAllVisibleCategory() {
        visibleCategory.removeAll()
    }
    
    func createNewTracker(tracker: Tracker) {
        var trackers: [Tracker] = []
        guard let list = categories.first else { return }
        for tracker in list.tracker {
            trackers.append(tracker)
        }
        trackers.append(tracker)
        categories = [TrackerCategory(title: .badHabits, tracker: trackers)]
    }
    
    func createNewCategory(newCategory: TrackerCategory) {
        categories.append(newCategory)
    }
    
    func checkIfCategoryIsEmpty() -> Bool {
        categories.isEmpty
    }
    
    func checkIfTrackerStorageIsEmpty() -> Bool {
        categories[0].tracker.isEmpty
    }
    
    func checkIfVisibleIsEmpty() -> Bool {
        if visibleCategory.isEmpty {
            return true
        }
        if visibleCategory[0].tracker.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getTrackerDetails(section: Int, item: Int) -> Tracker {
        visibleCategory[section].tracker[item]
    }
    
    func getNumberOfCategories() -> Int {
        visibleCategory.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        visibleCategory[section].tracker.count
    }
    
    func getTitleForSection(sectionNumber: Int) -> String {
        visibleCategory[sectionNumber].title.rawValue
    }
}

// MARK: - Enums

enum CategoryList: String {
    case goodHabits = "Полезные привычки"
    case badHabits = "Вредные привычки"
}
