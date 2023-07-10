//
//  UIImageView+Extensions.swift
//  Ricked
//
//  Created by Антон Нехаев on 30.06.2023.
//

import UIKit

let imageCache = NSCache<NSURL, UIImage>()

extension UIImageView {
    
    func download(from url: NSURL, mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let cachedImage = imageCache.object(forKey: url){
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType,
                  mimeType.hasPrefix("image"),
                  let data = data,
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: url)
                self.image = image
            }
        }.resume()
    }
    
    func download(from link: String, contentMode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        download(from: url as NSURL, mode: contentMode)
    }
}
