//
//  AddNewTrackerViewController.swift
//  Tracker
//
//  Created by Mike Somov on 26.04.2025.
//

import UIKit

// MARK: - Protocols

protocol DismissProtocol: AnyObject {
    func dismissView()
}

// MARK: - Classes

final class AddNewTrackerViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: ReloadCollectionProtocol?
    
    // MARK: - Private properties
    
    private lazy var newHabitButton: UIButton = {
        let newHabitButton = TrackerButton(title: "Привычка")
        newHabitButton.addTarget(self, action: #selector(makeNewHabit), for: .touchUpInside)
        return newHabitButton
    }()
    
    private lazy var newEventButton: UIButton = {
        let newEventButton = TrackerButton(title: "Нерегулярное событие")
        newEventButton.addTarget(self, action: #selector(makeNewEvent), for: .touchUpInside)
        return newEventButton
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [newHabitButton, newEventButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        title = "Создание трекера"
        view.backgroundColor = .ypWhite
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func makeNewHabit(sender: UIButton) {
        sender.showAnimation {
            let newHabitViewController = NewHabitViewController()
            newHabitViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: newHabitViewController)
            self.present(navigationController, animated: true)
        }
    }
    
    @objc private func makeNewEvent(sender: UIButton) {
        sender.showAnimation {
            let newEventViewController = NewEventViewController()
            newEventViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: newEventViewController)
            self.present(navigationController, animated: true)
        }
    }
}


// MARK: - Extensions

extension AddNewTrackerViewController: DismissProtocol {
    func dismissView() {
        dismiss(animated: true) {
            self.delegate?.reloadCollection()
        }
    }
}
