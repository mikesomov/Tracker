//
//  TrackerButton.swift
//  Tracker
//
//  Created by Mike Somov on 23.04.2025.
//

import UIKit

final class TrackerButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = .ypBlack
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.setTitleColor(.ypWhite, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
