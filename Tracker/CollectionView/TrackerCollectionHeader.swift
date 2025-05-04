//
//  TrackerCollectionHeader.swift
//  Tracker
//
//  Created by Mike Somov on 23.04.2025.
//

import UIKit

final class TrackerCollectionHeader: UICollectionReusableView {
    
    // MARK: - Public properties
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVisuals()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Public properties
    
    func setupVisuals() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    func configureTitle(_ text: String) {
        titleLabel.text = text
    }
}
