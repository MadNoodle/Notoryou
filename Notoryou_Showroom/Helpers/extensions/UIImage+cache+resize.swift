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
  
  /// Resize an image to a size in px and preserve aspectRatio
  ///
  /// - Parameter newWidth: CGFLOAT width
  /// - Returns: UIImage resized Image
  func resize(to newWidth: CGFloat) -> UIImage {
    // define new scale
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    // capture image and create an image with desired size
    UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
    self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}

/// Initialize the cache storage for images
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  
  /// Load and cache an image with the image url as string
  ///
  /// - Parameter urlString: String
  func load(urlString: String) {
    // Convert string to url
    let url = URL(string: urlString)
    image = nil
    
    // check and load image from cache
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = imageFromCache
      return
    }
    
    // Fetch image from remote
    let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
      // send to bg queue
      DispatchQueue.main.async {
        // unwrap image as data
        if let data = data {
          // Store in cache
          if let imageToCache = UIImage(data: data) {
            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            self.image = imageToCache
          }
        } else if let error = error  {
          print("USER INFO ERROR: \(error.localizedDescription)")
          // placeholder Image
          self.image = #imageLiteral(resourceName: "logonb")
        }
      }
    }
    task.resume()
  }
}
