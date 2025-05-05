//
//  Tracker.swift
//  Tracker
//
//  Created by Mike Somov on 17.04.2025.
//

import UIKit

// MARK: - Structs

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
}
