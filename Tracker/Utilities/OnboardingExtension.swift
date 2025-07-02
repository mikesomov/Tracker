//
//  OnboardingExtension.swift
//  Tracker
//
//  Created by Mike Somov on 18.06.2025.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
    }

    static func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Keys.isFirstLaunch) == nil {
            defaults.set(false, forKey: Keys.isFirstLaunch)
            return true
        }
        return false
    }
}
