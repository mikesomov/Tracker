//
//  EmojiColorCollectionViewCell.swift
//  Tracker
//
//  Created by Mike Somov on 05.05.2025.
//

import UIKit

final class EmojiColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.layer.cornerRadius = 8
        emojiLabel.font = .systemFont(ofSize: 38)
        emojiLabel.layer.masksToBounds = true
        return emojiLabel
    }()
    
    lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.layer.cornerRadius = 8
        colorLabel.layer.masksToBounds = true
        return colorLabel
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVisuals()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Public methods
    
    func configureCell(emoji: String, color: UIColor) {
        emojiLabel.text = emoji
        colorLabel.backgroundColor = color
    }
    
    func configureSelectedEmojiCell() {
        backgroundColor = .ypLightGray
        layer.cornerRadius = 16
    }
    
    func configureSelectedColorCell(with color: UIColor) {
        layer.borderWidth = 4
        layer.cornerRadius = 12
        layer.borderColor = color.withAlphaComponent(0.4).cgColor
    }
    
    func setupVisuals() {
        addSubviews(colorLabel, emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 40),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40),
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40),
            colorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
