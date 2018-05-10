//
//  UserAlert.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 10/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

class UserAlert {
  
  class func show(title: String, message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    controller.present(alert, animated: true)
  }
}
