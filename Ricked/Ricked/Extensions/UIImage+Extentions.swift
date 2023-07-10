//
//  Extention+UIImage.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit


extension UIImage {
    static let systemImageNames = [
        "circle.fill",
        "square.fill",
        "triangle.fill",
        "heart.fill",
        "star.fill",
        "bolt.fill",
        "cloud.fill",
        "moon.fill",
        "sun.max.fill",
        "person.fill",
        "house.fill",
        "cart.fill",
        "bag.fill",
        "gift.fill",
        "bell.fill",
        "camera.fill",
        "car.fill",
        "bus.fill",
        "airplane",
        "bicycle",
        "book.fill"
    ]
    
    
    static func getRandom() -> UIImage {
        let randomIndex = Self.systemImageNames.indices.randomElement()!
        return UIImage(systemName: systemImageNames[randomIndex])!
    }
}


extension UIImage {
    static var rickImage: UIImage? {
        UIImage(named: "Rick")
    }
    
    static func appImage(_ name: String) -> UIImage? {
        switch name {
        case "Rick":
            return UIImage(named: "Rick")
        default:
            return nil
        }
    }
    
    static var starFilled: UIImage? {
        UIImage(systemName: "star.fill")
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

