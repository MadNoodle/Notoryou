//
//  VisitDelegate.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 12/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/// Protocol to pass visit between controllers
protocol VisitDelegate: class {
  /// currently displayed visit
  var currentShow: Show? {get set}
  /// Method to pass visit between controllers
  ///
  /// - Returns: Show?
  func sendVisit() -> Show?
}
