//
//  TrackerTable.swift
//  Tracker
//
//  Created by Mike Somov on 27.04.2025.
//

import UIKit

final class TrackerTable: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.layer.cornerRadius = 16
        self.rowHeight = 75
        self.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .ypBackground
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder) has not been implemented")
        return nil
    }
}
