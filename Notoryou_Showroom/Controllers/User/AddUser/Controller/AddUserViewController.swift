//
//  AddUserViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 16/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
  
  // MARK: - PROPERTIES
  /// pickerView for acces level choice
   let pickerData = [NSLocalizedString("Administrator", comment: ""), NSLocalizedString("Registered user", comment: ""), NSLocalizedString("Visitor", comment: "")]

  // MARK: - OUTLETS
  @IBOutlet weak var lastNameField: CustomTextField!
  @IBOutlet weak var passwordField: CustomTextField!
  @IBOutlet weak var firstNameField: CustomTextField!
  @IBOutlet weak var emailField: CustomTextField!
  @IBOutlet weak var picker: UIPickerView!
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // setup delegations
    lastNameField.delegate = self
    firstNameField.delegate = self
    emailField.delegate = self
    passwordField.delegate = self
    picker.delegate = self
    picker.dataSource = self
    
    // add save button
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .done, target: self, action: #selector(createUser))
    self.navigationItem.rightBarButtonItem = addButton
    
    }

  // MARK: - SELECTORS
  @objc func createUser() {
    // check if all required fields are populated
    if emailField.text != "" && firstNameField.text != "" && lastNameField.text != "" && passwordField.text != "" {
      
        // grab authorization from picker
      let selectedValue = picker.selectedRow(inComponent: 0)
      // create saving time
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy MM dd"
      let saveDate = formatter.string(from: Date())
      
        // Save to firebase
      FirebaseManager.shared.createUser(username: emailField.text!, lastName: lastNameField.text!, firstName: firstNameField.text!, date: saveDate, password: passwordField.text!, authorization: selectedValue, completion: { (_, error) in
        if error != nil {
          // alert for problem
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        // confirm creation
        UserAlert.show(title: NSLocalizedString("Congratulations", comment: ""), message: NSLocalizedString("Your user has been created", comment: ""), controller: self)
        self.dismiss(animated: true)
      })
      }
  }
}

// MARK: - UITextFieldDelegate
  extension AddUserViewController: UITextFieldDelegate {
    
    ///  When user touches outside of the text field. it validates his text
    /// and send translation request. the keyboard disappear.
    ///
    /// - Parameters:
    ///   - touches: Touch
    ///   - event: event that trigger the action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
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

// MARK:- PICKERVIEW DELEGATE
extension AddUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  // The number of columns of data
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    // change picker text color to white
    let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
    return attributedString
  }
}

