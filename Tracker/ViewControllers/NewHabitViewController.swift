//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Mike Somov on 26.04.2025.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var eventName = ""
    private var selectedCategory: TrackerCategory?
    private var selectedSchedule: [Weekday] = []
    private let tableList = ["Категория", "Расписание"]
    private let textField = TrackerTextField(placeHolder: "Введите название трекера")
    private let trackerStorage = TrackerStorage.shared
    
    private let emojiList = ["🙂","😻","🌺","🐶","❤️","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    private let colorList: [UIColor] = [
        .ypColor1,
        .ypColor2,
        .ypColor3,
        .ypColor4,
        .ypColor5,
        .ypColor6,
        .ypColor7,
        .ypColor8,
        .ypColor9,
        .ypColor10,
        .ypColor11,
        .ypColor12,
        .ypColor13,
        .ypColor14,
        .ypColor15,
        .ypColor16,
        .ypColor17,
        .ypColor18
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.isEnabled = false
        createButton.backgroundColor = .ypGray
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.ypBlack, for: .normal)
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        textField.delegate = self
        print("NewHabitViewController loaded")
    }
    
    // MARK: - Public methods
    
    func buttonValidation() {
        
        if selectedCategory != nil && !eventName.isEmpty && !selectedSchedule.isEmpty {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
            createButton.setTitleColor(.ypWhite, for: .normal)
        }
    }
    
    func setupVisuals() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        view.addSubviews(textField, stackView, tableView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count))
        ])
    }
    
    // MARK: - Private methods
    
    @objc private func create(_ sender: UIButton) {
        let newTracker = Tracker(
            id: UUID(),
            title: eventName,
            color: .ypColor3,
            emoji: "🍒",
            schedule: selectedSchedule)
        
        trackerStorage.createNewTracker(tracker: newTracker)
        dismiss(animated: true)
        self.delegate?.dismissView()
    }
    
    @objc private func cancel(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Delegates
    
    weak var delegate: DismissProtocol?
}

// MARK: - Extensions

extension NewHabitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        let item = "\(tableList[indexPath.row])"
        cell.textLabel?.text = item
        if item == "Категория" {
            cell.detailTextLabel?.text = selectedCategory?.title.rawValue
            cell.detailTextLabel?.textColor = .ypGray
        }
        if item == "Расписание" {
            var text: [String] = []
            for day in selectedSchedule {
                text.append(day.rawValue)
            }
            cell.detailTextLabel?.text = text.joined(separator: ", ")
            cell.detailTextLabel?.textColor = .ypGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = tableList[indexPath.row]
        
        if selectedItem == "Категория" {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        }
        
        if selectedItem == "Расписание" {
            let scheduleController = WeekDaySelectorViewController()
            scheduleController.delegate = self
            navigationController?.pushViewController(scheduleController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        eventName = textField.text ?? ""
        buttonValidation()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        buttonValidation()
        return true
    }
}

extension NewHabitViewController: CategoryViewControllerDelegate {
    
    func categoryScreen(_ screen: CategoryViewController, didSelectCategory category: TrackerCategory) {
        selectedCategory = category
        buttonValidation()
        tableView.reloadData()
    }
}

extension NewHabitViewController: WeekdaySelectorDelegate {
    func weekdaySelectorScreen(_ screen: WeekDaySelectorViewController, didSelectDays schedule: [Weekday]) {
        selectedSchedule = schedule
        buttonValidation()
        tableView.reloadData()
    }
}
