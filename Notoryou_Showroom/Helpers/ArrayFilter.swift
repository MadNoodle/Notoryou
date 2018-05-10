//
//  ArrayFilter.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 10/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

extension Array {
  
  func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
    
    var results = [Element]()
    
    forEach { (element) in
      
      let existingElements = results.filter {
        print("DUPLICATE \(element)")
        return includeElement(element, $0)
      }
      
      if existingElements.count == 0 {
        results.append(element)
      }
    }
    return results
  }
}
