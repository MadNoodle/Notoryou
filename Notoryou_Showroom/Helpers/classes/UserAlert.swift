//
//  UserAlert.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 10/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

/// Class to display user Alert in a controller
class UserAlert {
  
  /// Show the alert Controller in a controller
  ///
  /// - Parameters:
  ///   - title: String
  ///   - message: String
  ///   - controller: Controller
  class func show(title: String, message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
    controller.present(alert, animated: true)
  }
}
