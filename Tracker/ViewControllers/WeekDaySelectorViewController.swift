//
//  WeekDaySelectorViewController.swift
//  Tracker
//
//  Created by Mike Somov on 23.04.2025.
//

import UIKit

// MARK: Protocols

protocol WeekdaySelectorDelegate: AnyObject {
    func weekdaySelectorScreen(_ screen: WeekDaySelectorViewController, didSelectDays schedule: [Weekday])
}

// MARK: - Classes

final class WeekDaySelectorViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let daysOfWeek: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private let daysOfWeekView = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var selectedDays: [Weekday] = []
    
    private lazy var button: UIButton = {
        let button = TrackerButton(title: "Готово")
        button.addTarget(self, action: #selector(dismissView), for:.touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(WeekDaysSelector.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        let tableCount: CGFloat = CGFloat(daysOfWeekView.count)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * tableCount).isActive = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        view.backgroundColor = .ypWhite
        title = "Расписание"
        navigationItem.hidesBackButton = true
        view.addSubview(button)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    @objc private func dismissView(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.weekdaySelectorScreen(self, didSelectDays: self.selectedDays)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Delegates
    
    weak var delegate: WeekdaySelectorDelegate?
}

// MARK: - Enums

enum Weekday: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вск"
}

// MARK: - Extensions

extension WeekDaySelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeekDaysSelector else {
            return UITableViewCell()
        }
        cell.configureCell(daysOfWeekView[indexPath.row], daysOfWeek[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeekView.count
    }
}

extension WeekDaySelectorViewController: WeekDaysSelectorSwitch {

    func weekDayAppend(_ weekDay: Weekday) {
        selectedDays.append(weekDay)
    }
    
    func weekDayRemove(_ weekDay: Weekday) {
        if let index = selectedDays.firstIndex(of: weekDay) {
            selectedDays.remove(at: index)
        }
    }
}
