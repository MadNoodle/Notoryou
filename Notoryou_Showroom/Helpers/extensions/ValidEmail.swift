//
//  ValidEmail.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

extension String {
  /// Validate email string
  ///
  /// - parameter email: A String that rappresent an email address
  ///
  /// - returns: A Boolean value indicating whether an email is valid.
  func isValidEmailAddress() -> Bool {
    
    /// Bool to store the possible answer from test
    var returnValue = true
    /// regex to check email
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    // check if mail is valid or not
    do {
      let regex = try NSRegularExpression(pattern: emailRegEx)
      let nsString = self as NSString
      let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
      
      if results.count == 0 {
        returnValue = false
      }
      
    } catch let error as NSError {
      print("invalid regex: \(error.localizedDescription)")
      returnValue = false
    }
    
    return  returnValue
  }
}
