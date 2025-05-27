//
//  WeekDaysSelector.swift
//  Tracker
//
//  Created by Mike Somov on 23.04.2025.
//

import UIKit

// MARK: - Protocols

protocol WeekDaysSelectorSwitch: AnyObject {
    func weekDayAppend(_ weekDay: Int)
    func weekDayRemove(_ weekDay: Int)
}

// MARK: - Classes

final class WeekDaysSelector: UITableViewCell {
    
    // MARK: - Public properties
    
    var weekDay: Int?
    
    // MARK: - Private properties
    
    private lazy var weekDayTitle: UILabel = {
        let weekDayTitle = UILabel()
        weekDayTitle.translatesAutoresizingMaskIntoConstraints = false
        return weekDayTitle
    }()
    
    private lazy var switchSelector: UISwitch = {
        let switchSelector = UISwitch()
        switchSelector.onTintColor = .ypBlue
        switchSelector.translatesAutoresizingMaskIntoConstraints = false
        switchSelector.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return switchSelector
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupVisuals()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Public methods
    
    func configureCell(_ weekDayView: String, _ weekDay: Int) {
        backgroundColor = .ypBackground
        weekDayTitle.text = weekDayView
        self.weekDay = weekDay
    }
    
    // MARK: - Private methods
    
    @objc private func switchAction(_ sender: UISwitch) {
        guard let weekDay = weekDay else { return }
        sender.isOn ? delegate?.weekDayAppend(weekDay) : delegate?.weekDayRemove(weekDay)
    }
    
    private func setupVisuals() {
        contentView.addSubview(weekDayTitle)
        contentView.addSubview(switchSelector)
        NSLayoutConstraint.activate([
            weekDayTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            weekDayTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            switchSelector.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Delegates
    
    weak var delegate: WeekDaysSelectorSwitch?
}
