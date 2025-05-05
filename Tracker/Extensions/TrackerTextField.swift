//
//  TrackerTextField.swift
//  Tracker
//
//  Created by Mike Somov on 28.03.2025.
//

import UIKit

final class TrackerTextField: UITextField {
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        self.backgroundColor = .ypBackground
        self.textColor = .ypBlack
        self.placeholder = placeHolder
        self.addPadding()
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
