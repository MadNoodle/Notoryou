//
//  UIImage+resize.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 12/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  func resize(to newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
    self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  func load(urlString: String) {
    let url = URL(string: urlString)
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = imageFromCache
      return
    }

    let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      DispatchQueue.main.async {
        guard let imageToCache = UIImage(data: data!) else { return}
        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
        self.image = imageToCache
      }
    }
    task.resume()
  }
}
