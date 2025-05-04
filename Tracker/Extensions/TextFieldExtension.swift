//
//  TextFieldExtension.swift
//  Tracker
//
//  Created by Mike Somov on 28.03.2025.
//

import UIKit

extension UITextField {
    func addPadding() {
        let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
