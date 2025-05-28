//
//  WeekdayExtension.swift
//  Tracker
//
//  Created by Mike Somov on 06.05.2025.
//

import Foundation

extension Int {
    
    func getShortDay() -> String {
        switch self {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return  ""
        }
    }
}
