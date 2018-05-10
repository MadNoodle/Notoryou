//
//  AddViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 09/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import SDWebImage

class AddViewController: UIViewController, UITextFieldDelegate {

// to do rajouter un textfield pour url image

  @IBOutlet weak var previewTextField: UITextField!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()

    urlTextField.delegate = self
    titleTextField.delegate = self
    
    }



  @IBAction func AddVisit(_ sender: UIButton) {
    var newShow: Show?
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MM dd"
    let saveDate = formatter.string(from: Date())
    if titleTextField != nil && urlTextField.text != nil && previewTextField.text != nil {
      FirebaseManager.shared.createVisit(user: "mathieu", date: saveDate, title: titleTextField.text!, id: urlTextField.text!, imageUrl: previewTextField.text!)
 
    }
    else {
      // todo rajouter une alerte
      print("fufill all fields")
    }
  }
  
  
  /// When user presses enter on keyboard. it validates his text
  /// and send translation request. the keyboard disappear.
  ///
  /// - Parameter textField:  input textField
  /// - Returns: Boolean
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return (true)
  }
  

}
