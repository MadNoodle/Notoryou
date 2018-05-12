//
//  VisitDelegate.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 12/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

protocol VisitDelegate: class {
  var currentShow: Show? {get set}
  func sendVisit() -> Show?
}
