//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Mike Somov on 29.04.2025.
//

import UIKit

// MARK: - Protocols

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryScreen(_ screen: CategoryViewController, didSelectCategory category: TrackerCategory)
}

// MARK: - Classes

final class CategoryViewController: UIViewController {
    
    // MARK: - Public properties
    
    var trackerStorage = TrackerStorage.shared
    
    // MARK: - Private properties
    
    private let label = TrackerTextLabel(text: "Привычки и события можно объяденить по группам", fontSize: 12, fontWeight: .medium)
    
    private lazy var button: UIButton = {
        let button = TrackerButton(title: "Добавить новую категорию")
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "nothing")
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        setupContent()
    }
    
    // MARK: - Private methods
    
    func setupVisuals() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        view.addSubview(button)
        view.addSubview(stackView)
        view.addSubview(tableView)
        let numberOfRows = trackerStorage.getNumberOfCategories()
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * numberOfRows)),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupContent() {
        if trackerStorage.checkIfCategoryIsEmpty() {
            tableView.isHidden = true
            stackView.isHidden = false
        } else {
            tableView.isHidden = false
            stackView.isHidden = true
        }
    }
    
    // MARK: - Private methods
    
    @objc private func addNewCategory(_ sender: UIButton) {
        sender.showAnimation {
            let addNewCategory = AddNewTrackerViewController()
            self.navigationController?.pushViewController(addNewCategory, animated: true)
        }
    }
    
    // MARK: - Delegates
    
    weak var delegate : CategoryViewControllerDelegate?
}

// MARK: - Extensions

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableVIew: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerStorage.getNumberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = trackerStorage.categories[indexPath.row].title.rawValue
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.categoryScreen(self, didSelectCategory: trackerStorage.categories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

extension CategoryViewController: UITableViewDelegate {
    
}
