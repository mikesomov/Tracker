//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Mike Somov on 25.06.2025.
//

import Foundation

// MARK: - Classes

final class CategoryViewModel {
    
    // MARK: - Public properties
    
    let trackerCategoryStore = TrackerCategoryStore()
    
    var categories = [TrackerCategory]()
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Public methods
    
    func fetchCategory(callBack: @escaping () -> ()) {
        categories = trackerCategoryStore.fetchAllCategories().compactMap { category in
            self.trackerCategoryStore.decodingCategory(from: category)
        }
        callBack()
    }
    
    func didSelectModelAtIndex(_ indexPath: IndexPath) -> TrackerCategory {
        return categories[indexPath.row]
    }
}
