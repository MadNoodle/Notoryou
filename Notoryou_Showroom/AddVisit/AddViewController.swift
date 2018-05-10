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

  var isPublic = 0

  @IBOutlet weak var previewTextField: UITextField!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()
  
    // delegation
    urlTextField.delegate = self
    titleTextField.delegate = self
    
    // add save button
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(saveVisit))
    self.navigationItem.rightBarButtonItem = addButton
    }


  @IBAction func setPublic(_ sender: UISwitch) {
    if sender.isOn {
      isPublic = 2
       // show alert to tell it will be visible by all users
       UserAlert.show(title: "Attention", message: "Tous les utilisateurs de Notoryou pourrons accèder à votre visite", controller: self)
    } else {
      isPublic = 0
     
     
    }
    print(isPublic)
  }
  
  @objc func saveVisit() {
    if titleTextField.text != "" && urlTextField.text != "" && previewTextField.text != "" {
      
      // create saving time
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy MM dd"
      let saveDate = formatter.string(from: Date())
      
      
      // save object to firebase
      FirebaseManager.shared.createVisit(user: "mathieu", date: saveDate, title: titleTextField.text!, id: urlTextField.text!, imageUrl: previewTextField.text!, visibility: isPublic)
      UserAlert.show(title: "Bravo", message: "Votre visite a été sauvegardée", controller: self)
    } else {
      UserAlert.show(title: "Attention", message: "Veuillez remplir tous les champs", controller: self)
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
