//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Mike Somov on 29.04.2025.
//

import UIKit

// MARK: - Protocols

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryScreen(didSelectCategory category: TrackerCategory)
}

// MARK: - CategoryViewController

final class CategoryViewController: UIViewController {

    // MARK: - Public

    var viewModel: CategoryViewModel?
    var onCategorySelected: ((TrackerCategory) -> Void)?

    // MARK: - Private

    private let label = TrackerTextLabel(
        text: "Привычки и события можно\nобъединить по смыслу",
        fontSize: 12,
        fontWeight: .medium
    )

    private lazy var button: UIButton = {
        let button = TrackerButton(title: "Добавить категорию")
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

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = TrackerTable()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypLightGray
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var selectedCategoryIndex: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        setupContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true

        viewModel?.fetchCategory {
            self.tableView.reloadData()
            self.updateTableHeight()
            self.setupContent()
        }
    }

    // MARK: - Setup UI

    private func setupVisuals() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true

        view.addSubview(button)
        view.addSubview(stackView)
        view.addSubview(containerView)
        containerView.addSubview(tableView)

        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        tableViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }

    private func setupContent() {
        guard let count = viewModel?.categories.count, count > 0 else {
            stackView.isHidden = false
            containerView.isHidden = true
            return
        }

        stackView.isHidden = true
        containerView.isHidden = false
    }

    private func updateTableHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.constant = contentHeight
    }

    // MARK: - Actions

    @objc private func addNewCategory(_ sender: UIButton) {
        sender.showAnimation {
            let addNewCategory = AddNewCategoryViewController()
            self.navigationController?.pushViewController(addNewCategory, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setupContent()
        return viewModel?.categories.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel?.categories[indexPath.row].title ?? "нет названия"
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .ypBackground

        cell.accessoryType = (indexPath == selectedCategoryIndex) ? .checkmark : .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath
        tableView.reloadData()

        if let selected = viewModel?.didSelectModelAtIndex(indexPath) {
            onCategorySelected?(selected)
            self.dismiss(animated: true)
        }
    }
}
