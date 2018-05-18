//
//  ArrayFilter.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 10/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

// MARK: - Array Extension
extension Array {
  
  /// This methods seeks for duplicate in an array of Elements and remove them
  ///
  /// - Parameter includeElement: Element
  /// - Returns: [Element]
  func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
    
    var results = [Element]()
    // Iterate throught elements
    forEach { (element) in
      
      let existingElements = results.filter {
        return includeElement(element, $0)
      }
      
      if existingElements.count == 0 {
        results.append(element)
      }
    }
    return results
  }
}
