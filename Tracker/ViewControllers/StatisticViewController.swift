//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Mike Somov on 27.03.2025.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let statisticData: [String] = []
    private let label = TrackerTextLabel(text: "Nothing to review", fontSize: 12, fontWeight: .medium)
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "emptyStats")
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        setupContent()
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupContent() {
        if statisticData.isEmpty {
            addHolderView()
        } else {
            addStatisticView()
        }
    }
    
    private func addHolderView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func addStatisticView() {
        
    }
}
