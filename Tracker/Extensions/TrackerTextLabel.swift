//
//  TrackerTextLabel.swift
//  Tracker
//
//  Created by Mike Somov on 28.03.2025.
//

import UIKit

final class TrackerTextLabel: UILabel {
    
    init(text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.numberOfLines = 0
        self.textAlignment = .center
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
