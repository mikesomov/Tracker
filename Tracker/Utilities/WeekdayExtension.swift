//
//  WeekdayExtension.swift
//  Tracker
//
//  Created by Mike Somov on 06.05.2025.
//

import Foundation

extension Int {
    func getFullDay() -> String {
        switch self {
        case 1:
            return "Понедельник"
        case 2:
            return "Вторник"
        case 3:
            return "Среда"
        case 4:
            return "Четверг"
        case 5:
            return "Пятница"
        case 6:
            return "Суббота"
        case 7:
            return "Воскресенье"
        default:
            return ""
        }
    }
    
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
