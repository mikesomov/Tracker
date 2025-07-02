//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Mike Somov on 23.04.2025.
//

import UIKit

// MARK: - Protocols

protocol TrackerCompletedDelegate: AnyObject {
    func completedTracker(id: UUID, indexPath: IndexPath)
    func uncompletedTracker(id: UUID, indexPath: IndexPath)
}

// MARK: - Classes

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    lazy var bodyView: UIView = {
        let bodyView = UIView()
        bodyView.layer.cornerRadius = 16
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }()
    
    lazy var emojiView: UIView = {
        let emojiView = UIView()
        emojiView.layer.cornerRadius = 12
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .ypWhite
        emojiView.alpha = 0.3
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        return emojiView
    }()
    
    lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 12, weight: .medium)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var dayCounterLabel: UILabel = {
        let dayCounterLabel = UILabel()
        dayCounterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dayCounterLabel.textColor = .ypBlack
        dayCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayCounterLabel
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.layer.cornerRadius = 17
        plusButton.addTarget(self, action: #selector(trackerCompletedTapped), for: .touchUpInside)
        return plusButton
    }()
    
    // MARK: - Private properties
    
    private var isCompletedToday: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var allowManualTap = false
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVisuals()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder) has not been implemented")
        return nil
    }
    
    // MARK: - Delegates
    
    weak var delegate: TrackerCompletedDelegate?
    
    // MARK: - Public methods
    
    func configureCell(tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.allowManualTap = true
        self.indexPath = indexPath
        self.trackerID = tracker.id
        self.isCompletedToday = isCompletedToday
        titleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        dayCounterLabel.text = "\(completedDays) дней"
        
        bodyView.backgroundColor = tracker.color
        plusButton.tintColor = tracker.color
        
        let image = isCompletedToday ? UIImage(named: "doneButton") : UIImage(named: "plusButton")
        plusButton.setImage(image, for: .normal)
    }
    
    // MARK: Private methods
    
    private func setupVisuals() {
        addSubviewsInCell(bodyView, emojiView, emojiLabel, titleLabel, dayCounterLabel, plusButton)
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 90),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -12),
            
            dayCounterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dayCounterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dayCounterLabel.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 16),
            
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8)
        ])
    }
    
    @objc private func trackerCompletedTapped() {
        guard allowManualTap else {
            return
        }
        
        guard let trackerID = trackerID,
              let indexPath = indexPath else {
            assertionFailure("no trackerID or indexPath")
            return
        }
        
        allowManualTap = false
        
        if isCompletedToday {
            delegate?.uncompletedTracker(id: trackerID, indexPath: indexPath)
        } else {
            delegate?.completedTracker(id: trackerID, indexPath: indexPath)
        }
    }
}
