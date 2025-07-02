//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Mike Somov on 30.06.2025.
//

import UIKit

final class AddNewCategoryViewController: UIViewController {
    
    // MARK: - Public properties
    
    let trackerCategoryStore = TrackerCategoryStore()
    var onCategoryCreated: (() -> Void)?
    
    // MARK: - Private properties
    
    private var textField = TrackerTextField(placeHolder: "Введите название категории")
    private var enteredCategoryName = ""
    
    private lazy var createCategoryButton: UIButton = {
        let button = TrackerButton(title: "Готово")
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        textField.delegate = self
        buttonValidation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true    }
    
    // MARK: - Public methods
    
    func buttonValidation() {
        if enteredCategoryName.count > 0
        {
            createCategoryButton.isEnabled = true
            createCategoryButton.backgroundColor = .ypBlack
            createCategoryButton.setTitleColor(.ypWhite, for: .normal)
        } else {
            createCategoryButton.isEnabled = false
            createCategoryButton.backgroundColor = .ypGray
            createCategoryButton.setTitleColor(.ypWhite, for: .normal)
        }
    }
    
    // MARK: - Private methods
    
    private func setupVisuals() {
        
        view.backgroundColor = .ypWhite
        title = "Новая категория"
        view.addSubview(createCategoryButton)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func addNewCategory(_ sender: UIButton) {
        sender.showAnimation { [self] in
            trackerCategoryStore.createCategory(TrackerCategory(title: enteredCategoryName, trackers: []))
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddNewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enteredCategoryName = textField.text ?? ""
        buttonValidation()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enteredCategoryName = textField.text!
        textField.resignFirstResponder()
        buttonValidation()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
    }
}
