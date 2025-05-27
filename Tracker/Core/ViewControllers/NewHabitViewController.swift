//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Mike Somov on 26.04.2025.
//

import UIKit

// MARK: - Protocols

protocol CreateTrackerProtocol: AnyObject {
    func createHabitOrEvent(_ tracker: Tracker, _ category: String)
}

final class NewHabitViewController: UIViewController {
    
    // MARK: - Public properties
    
    let itemsInRow: CGFloat = 6
    let space: CGFloat = 5
    let outerMargin: CGFloat = 18
    
    // MARK: - Private properties
    
    private var habitName = ""
    private var selectedCategory: TrackerCategory?
    private var selectedSchedule: [Int] = []
    private let tableList = ["Категория", "Расписание"]
    private let textField = TrackerTextField(placeHolder: "Введите название трекера")
    private var selectedColor: (color: UIColor?, item: IndexPath?)
    private var selectedEmoji: (emoji: String?, item: IndexPath?)
    
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
    
    private lazy var limitLabel: UILabel = {
        let limitLabel = TrackerTextLabel(text: "Ограничение 38 символов", fontSize: 17, fontWeight: .regular)
        limitLabel.textColor = .ypRed
        limitLabel.isHidden = true
        return limitLabel
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textField, limitLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var emojiColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(EmojiColorCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        return collectionView
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
    }
    
    // MARK: - Public methods
    
    func buttonValidation() {
        if selectedCategory != nil &&
            selectedColor.color != nil &&
            selectedSchedule.count > 0 &&
            selectedEmoji.emoji != nil &&
            habitName.count > 0 &&
            habitName.count <= 38
        {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
            createButton.setTitleColor(.ypWhite, for: .normal)
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
            createButton.setTitleColor(.ypBlack, for: .normal)
        }
    }
    
    func setupVisuals() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        view.addSubviews(textFieldStack, tableView, emojiColorCollectionView, stackView)
        
        NSLayoutConstraint.activate([
            textFieldStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldStack.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)),
            
            emojiColorCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiColorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            emojiColorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            emojiColorCollectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Private methods
    
    @objc private func create(_ sender: UIButton) {
        let newTracker = Tracker(id: UUID(),
                                 title: habitName,
                                 color: selectedColor.color ?? .cyan,
                                 emoji: selectedEmoji.emoji ?? "⚠️",
                                 schedule: selectedSchedule)
        
        dismiss(animated: true)
        self.delegate?.dismissView()
        self.createDelegate?.createHabitOrEvent(newTracker, selectedCategory?.title ?? "")
    }
    
    @objc private func cancel(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Delegates
    
    weak var delegate: DismissProtocol?
    weak var createDelegate: CreateTrackerProtocol?
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
            cell.detailTextLabel?.text = selectedCategory?.title
            cell.detailTextLabel?.textColor = .ypGray
        }
        if item == "Расписание" {
            var text: [String] = []
            for day in selectedSchedule {
                text.append(day.getShortDay())
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
        textField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        return text.count > 38 ? false : true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        habitName = text
        buttonValidation()
        if text.count >= 38 {
            limitLabel.isHidden = false
            return false
        } else {
            limitLabel.isHidden = true
            return true
        }
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
    func weekdaySelectorScreen(_ screen: WeekDaySelectorViewController, didSelectDays schedule: [Int]) {
        selectedSchedule = schedule
        buttonValidation()
        tableView.reloadData()
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
            switch section {
            case 0:
                return emojiList.count
            case 1:
                return colorList.count
            default:
                return 0
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? EmojiColorCollectionHeader else { return UICollectionReusableView() }
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            view.configureTitle("Emoji")
        case 1:
            view.configureTitle("Цвет")
        default:
            assertionFailure("Invalid section number")
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
            ) as? EmojiColorCollectionViewCell else {
                return UICollectionViewCell()
            }

            if indexPath.section == 0 {
                let emoji = emojiList[indexPath.item]
                cell.configureCell(emoji: emoji, color: .clear)
            } else {
                let color = colorList[indexPath.item]
                cell.configureCell(emoji: "", color: color)
            }

            return cell
        }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - space * (itemsInRow - 1) - outerMargin * 2) / itemsInRow
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 23, left: outerMargin, bottom: 23, right: outerMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerSize = CGSize(width: view.frame.width, height: 30)
        return headerSize
    }
}

extension NewHabitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        let sectionNumber = indexPath.section
        switch sectionNumber {
        case 0:
            if selectedEmoji.item != nil {
                let previousItem = selectedEmoji.item!
                let previousCell = collectionView.cellForItem(at: previousItem)
                previousCell?.backgroundColor = .clear
            }
            
            cell.configureSelectedEmojiCell()
            selectedEmoji.emoji = emojiList[indexPath.item]
            selectedEmoji.item = indexPath
        case 1:
            if selectedColor.item != nil {
                let previousItem = selectedColor.item!
                let previousCell = collectionView.cellForItem(at: previousItem)
                previousCell?.layer.borderWidth = 0
            }
            cell.configureSelectedColorCell(with: colorList[indexPath.item])
            selectedColor.color = colorList[indexPath.item]
            selectedColor.item = indexPath
        default:
            assertionFailure("Invalid section number")
        }
        buttonValidation()
    }
}
