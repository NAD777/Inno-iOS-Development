//
//  Extention+UILabel.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit

extension UILabel {
    func underline() {
        let underlineAttriString = NSAttributedString(string: "attriString",
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        attributedText = underlineAttriString
    }
}
