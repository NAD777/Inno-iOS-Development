//
//  Extention+UIView.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit

extension UIView {
    func roundCorners() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}

