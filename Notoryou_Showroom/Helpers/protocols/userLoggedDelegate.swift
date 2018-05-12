//
//  userLoggedDelegate.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 11/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

protocol UserLoggedDelegate: class {
  var currentUser: String { get set}
  func sendUser() -> String
}
