//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Mike Somov on 27.03.2025.
//

import UIKit

// MARK: Protocols

protocol ReloadCollectionProtocol: AnyObject {
    func reloadCollection()
}

final class TrackerViewController: UIViewController {
    
    // MARK: - Public properties
    
    let currentDate = Calendar.current
    
    // MARK: - Private properties
    
    private let labelHolder = TrackerTextLabel(text: "Что будем отслеживать?", fontSize: 12, fontWeight: .medium)
    private let filterHolder = TrackerTextLabel(text: "Ничего не найдено", fontSize: 12, fontWeight: .medium)
    private var completedTrackers: [TrackerRecord] = []
    private let trackerStorage = TrackerStorage.shared
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var stackViewEmptyHolder: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nothingImage, labelHolder])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nothingImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "nothing")
        return image
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collectionView
    }()
    
    private lazy var stackViewFilteredHolder: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [filteredImage, filterHolder])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var filteredImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "emptyStats")
        return image
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupVisuals()
        setupContent(Date())
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        view.backgroundColor = .ypWhite
        view.addSubviews(collectionView, stackViewEmptyHolder, stackViewFilteredHolder)
        
        NSLayoutConstraint.activate([
            stackViewEmptyHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewEmptyHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackViewEmptyHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nothingImage.heightAnchor.constraint(equalToConstant: 80),
            nothingImage.widthAnchor.constraint(equalToConstant: 80),
            
            stackViewFilteredHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewFilteredHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackViewFilteredHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filteredImage.heightAnchor.constraint(equalToConstant: 80),
            filteredImage.widthAnchor.constraint(equalToConstant: 80),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupContent(_ date: Date) {
        showTrackersInDate(date)
        reloadHolders()
    }
    
    private func showTrackersInDate(_ date: Date) {
        trackerStorage.removeAllVisibleCategory()
        let weekday = currentDate.component(.weekday, from: date)
        trackerStorage.addTrackerToVisibleTrackers(weekday: weekday)
        collectionView.reloadData()
    }
    
    private func checkIfTrackersCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
    
    private func reloadHolders() {
        let allTrackersEmpty = trackerStorage.checkIfTrackerStorageIsEmpty()
        let visibleTrackersEmpty = trackerStorage.checkIfVisibleIsEmpty()
        
        if allTrackersEmpty {
            collectionView.isHidden = true
            stackViewEmptyHolder.isHidden = false
            stackViewFilteredHolder.isHidden = true
        }
        if !allTrackersEmpty && visibleTrackersEmpty {
            collectionView.isHidden = true
            stackViewEmptyHolder.isHidden = true
            stackViewFilteredHolder.isHidden = false
        }
        if !allTrackersEmpty && !visibleTrackersEmpty {
            collectionView.isHidden = false
            stackViewEmptyHolder.isHidden = true
            stackViewFilteredHolder.isHidden = true
        }
    }
    
    private func setupNavigationBar() {
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem  = plusButton
        
        view.addSubview(datePicker)
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
        
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
    }
    
    @objc private func plusButtonTapped() {
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        let addNavigationController = UINavigationController(rootViewController: addNewTrackerViewController)
        present(addNavigationController, animated: true)
    }
    
    @objc private func pickerChanged() {
        setupContent(datePicker.date)
    }
}

// MARK: - Extensions

extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStorage.getNumberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStorage.getNumberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCollectionHeader else { return UICollectionReusableView() }
        let title = trackerStorage.getTitleForSection(sectionNumber: indexPath.section)
        view.configureTitle(title)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        let tracker = trackerStorage.getTrackerDetails(section: indexPath.section, item: indexPath.item)
        cell.delegate = self
        let isCompletedToday = checkIfTrackersCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.configureCell(tracker: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, indexPath: indexPath)
        
        if datePicker.date > Date() {
            cell.plusButton.isHidden = true
        } else {
            cell.plusButton.isHidden = false
        }
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCount: CGFloat = 2
        let space: CGFloat = 9
        let width: CGFloat = (collectionView.bounds.width - space - 32) / itemCount
        let height: CGFloat = 148
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerSize = CGSize(width: view.frame.width, height: 30)
        return headerSize
    }
}

extension TrackerViewController: ReloadCollectionProtocol {
    func reloadCollection() {
        setupContent(Date())
    }
}

extension TrackerViewController: TrackerCompletedDelegate {
    
    func completedTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
