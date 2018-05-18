//
//  CustomTextField.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 13/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Custom TextField for registration
class CustomTextField: UITextField {

    override func draw(_ rect: CGRect) {
      // Customize appearance
      self.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
      self.layer.borderColor = UIColor.white.cgColor
      self.layer.cornerRadius = 5.0
      self.layer.masksToBounds = true
      self.layer.borderWidth = 1.0
      self.textColor = .white
    }
}
