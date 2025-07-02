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

// MARK: - Classes

final class TrackerViewController: UIViewController {
    
    // MARK: - Public properties
    
    let currentDate = Calendar.current
    
    var weekDay = 0
    var trackers = [Tracker]()
    var categories = [TrackerCategory]()
    private var visibleCategories: [TrackerCategory] {
        return categories
            .map { cat in
                let todays = cat.trackers.filter { $0.schedule.contains(weekDay) }
                return TrackerCategory(title: cat.title, trackers: todays)
            }
            .filter { !$0.trackers.isEmpty }
    }
    
    // MARK: - Private properties
    
    private var completedTrackers: [TrackerRecord] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let searchController = UISearchController()
    
    private let labelHolder = TrackerTextLabel(text: "Что будем отслеживать?", fontSize: 12, fontWeight: .medium)
    private let filterHolder = TrackerTextLabel(text: "Ничего не найдено", fontSize: 12, fontWeight: .medium)
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Трекеры"
        
        setupNavigationBar()
        setupNavigationBar()
        setupVisuals()
        setupContent(Date())
        trackerCategoryStore.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
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
        self.weekDay = currentDate.component(.weekday, from: date)
        completedTrackers = trackerRecordStore.fetchRecords(for: date)
        fetchCategory()
        collectionView.reloadData()
        reloadHolders()
    }
    
    private func showTrackersInDate(_ date: Date) {
        fetchCategory()
        collectionView.reloadData()
    }
    
    private func loadCompletedTrackers(for date: Date) {
        completedTrackers = trackerRecordStore.fetchRecords(for: date)
    }
    
    private func checkIfTrackersCompletedToday(id: UUID) -> Bool {
        let result = completedTrackers.contains { record in
            let isSameDay = Calendar.current.isDate(record.date, inSameDayAs: datePicker.date)
            return record.id == id && isSameDay
            
        }
        return result
    }
    
    private func reloadHolders() {
        let allTrackersEmpty = categories.allSatisfy { $0.trackers.isEmpty }
        let visibleTrackersEmpty = visibleCategories.allSatisfy { $0.trackers.isEmpty }
        
        stackViewEmptyHolder.isHidden = !allTrackersEmpty
        collectionView.isHidden = visibleTrackersEmpty
        stackViewFilteredHolder.isHidden = allTrackersEmpty ? true : !visibleTrackersEmpty
    }
    
    private func setupNavigationBar() {
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem  = plusButton
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(datePicker)
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
        
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    @objc private func plusButtonTapped() {
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.delegate = self
        addNewTrackerViewController.createDelegate = self
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
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCollectionHeader else { return UICollectionReusableView() }
        let title = visibleCategories[indexPath.section].title
        view.configureTitle(title)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let isCompletedToday = completedTrackers.contains { $0.id == tracker.id }
        let completedDays = trackerRecordStore.fetchRecords(for: datePicker.date).filter { $0.id == tracker.id }.count
        
        cell.delegate = self
        cell.configureCell(
            tracker: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        
        cell.plusButton.isHidden = datePicker.date > Date()
        
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

extension TrackerViewController {
    private func fetchCategory() {
        let coreDataCategories = trackerCategoryStore.fetchAllCategories()
        categories = coreDataCategories.compactMap { coreDataCategory in
            trackerCategoryStore.decodingCategory(from: coreDataCategory)
        }
    }
    
    private func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: titleCategory)
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
        trackerRecordStore.addNewRecord(from: trackerRecord)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID, indexPath: IndexPath) {
        trackerRecordStore.deleteRecord(for: id, on: datePicker.date)
        
        completedTrackers.removeAll { record in
            Calendar.current.isDate(record.date, inSameDayAs: datePicker.date) && record.id == id
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
}

extension TrackerViewController: CreateTrackerProtocol {
    func createHabitOrEvent(_ tracker: Tracker, _ category: String) {
        let allCategories = trackerCategoryStore.fetchAllCategories()
        
        if allCategories.first(where: { $0.title == category }) == nil {
            let newCategory = TrackerCategory(title: category, trackers: [])
            trackerCategoryStore.createCategory(newCategory)
        }
        
        guard let refreshedCategory = trackerCategoryStore.fetchCategory(with: category) else {
            return
        }
        
        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: refreshedCategory.title ?? "")
        
        fetchCategory()
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate {
    func didUpdateData(in store: TrackerCategoryStore) {
        collectionView.reloadData()
    }
}

extension TrackerViewController:  UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            fetchCategory()
        } else {
            categories = trackerCategoryStore
                .fetchAllCategories()
                .compactMap { trackerCategoryStore.decodingCategory(from: $0) }
                .map { category in
                    let filteredTrackers = category.trackers.filter {
                        $0.title.lowercased().contains(searchText.lowercased())
                    }
                    return TrackerCategory(title: category.title, trackers: filteredTrackers)
                }
                .filter { !$0.trackers.isEmpty }
        }
        collectionView.reloadData()
        reloadHolders()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchCategory()
        collectionView.reloadData()
        reloadHolders()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.sizeToFit()
        }
    }
}
