//
//  userLoggedDelegate.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 11/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/// Protocol that allows user to pass user data between controllers
protocol UserLoggedDelegate: class {
  /// current logged user
  var currentUser: String { get set}
  /// send currentUSer to another controller
  func sendUser() -> String
}
