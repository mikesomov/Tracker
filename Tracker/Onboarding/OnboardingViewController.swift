//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Mike Somov on 18.06.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let isLastPage: Bool
    private let buttonAction: (() -> Void)?
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()
    
    // MARK: - Initialisers
    
    init(image: UIImage, buttonText: String, labelText: String, isLastPage: Bool = false, buttonAction: (() -> Void)? = nil) {
        self.isLastPage = isLastPage
        self.buttonAction = buttonAction
        super.init(nibName: nil, bundle: nil)
        backgroundImage.image = image
        button.setTitle(buttonText, for: .normal)
        label.text = labelText
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
    }
    
    // MARK: - Public methods
    
    func setupVisuals() {
        view.addSubviews(backgroundImage, button, label)
        
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: view.bounds.height),
            backgroundImage.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -160)
        ])
    }
    
    // MARK: - Private methods
    
    @objc private func buttonTapped() {
        if isLastPage {
            let window = UIApplication.shared.windows.first
            window?.rootViewController = TabBarViewController()
            window?.makeKeyAndVisible()
        } else {
            buttonAction?()
        }
    }
}
