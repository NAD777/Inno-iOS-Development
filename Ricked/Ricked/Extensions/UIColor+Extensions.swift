//
//  Extention+UIColor.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit

//enum AssetsColor {
//   case background
//}

extension UIColor {
//    static func appColor(_ name: AssetsColor) -> UIColor? {
//        switch name {
//        case .background:
//            return UIColor(named: "BackgroudColor")
//        }
//    }
    
    static var background: UIColor? {
        UIColor(named: "BackgroudColor")
    }
    
    static var cellBackground: UIColor? {
        UIColor(named: "CellBackgroudColor")
    }
}
