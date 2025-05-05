//
//  TrackerCell.swift
//  Tracker
//
//  Created by Mike Somov on 05.05.2025.
//

import UIKit

extension UICollectionViewCell {
    func addSubviewsInCell(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
