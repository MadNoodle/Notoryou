//
//  EditUserViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {
  
  // MARK: - PROPERTIES
  /// pickerView for acces level choice
  let pickerData = [NSLocalizedString("Administrator", comment: ""), NSLocalizedString("Registered user", comment: ""), NSLocalizedString("Visitor", comment: "")]
  /// Current selected user
  var currentUser: User!
  
  // MARK: - OUTLETS
  @IBOutlet weak var lastNameField: CustomTextField!
  @IBOutlet weak var firstNameField: CustomTextField!
  @IBOutlet weak var passwordField: CustomTextField!
  @IBOutlet weak var emailField: CustomTextField!
  @IBOutlet weak var picker: UIPickerView!
  
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var accessLevelLabel: UILabel!
  // MARK: - LIFECYLCE METHODS
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup delegations
    lastNameField.delegate = self
    firstNameField.delegate = self
    emailField.delegate = self
    passwordField.delegate = self
    picker.delegate = self
    picker.dataSource = self
    
    lastNameLabel.text = NSLocalizedString("Lastname", comment: "")
    firstNameLabel.text = NSLocalizedString("Firstname", comment: "")
    emailLabel.text = NSLocalizedString("E-mail", comment: "")
    passwordLabel.text = NSLocalizedString("Password", comment: "")
    accessLevelLabel.text = NSLocalizedString("Access level", comment: "")
    // populate fields
    lastNameField.text = currentUser.lastName
    firstNameField.text = currentUser.firstName
    emailField.text = currentUser.email
    passwordField.text = currentUser.password
    picker.selectRow(currentUser.authorization, inComponent: 0, animated: false)
    
    // Customize Navigation bar
    self.navigationController?.navigationBar.isTranslucent = false
    let editButton = UIBarButtonItem(title: NSLocalizedString("update", comment: ""), style: .plain, target: self, action: #selector(editUser))
    
    let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete "), style: .done, target: self, action: #selector(deleteUser))
    self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
  }
  
  /// Alllows the user to edit a user
  @objc func editUser() {
    // check required fields
    if lastNameField.text != "" && firstNameField.text != "" && emailField.text != "" && passwordField.text != "" {
      
      // create saving time
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy MM dd"
      let saveDate = formatter.string(from: Date())
      let userKey = currentUser.key
      
      // save object to firebase
      FirebaseManager.shared.updateUser(username: currentUser.username, key: userKey, lastName: lastNameField.text!, firstName: firstNameField.text!, date: saveDate, password: passwordField.text!, authorization: picker.selectedRow(inComponent: 0)) {(_, error) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        UserAlert.show(title: NSLocalizedString("Congratulations", comment: ""), message: NSLocalizedString("Your user has been updated", comment: ""), controller: self)
      }
      
    } else {
      UserAlert.show(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please fulfill required fields", comment: ""), controller: self)
    }
  }
  
  /// Handles the delation of a user in the firebase database
  @objc func deleteUser() {
    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("You are about to permanently delete a user", comment: ""), preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default) { (_) in
      
      // Send user back to collection
      let userVc = UserManagerViewController()
      self.navigationController?.pushViewController(userVc, animated: true)
      
      // delete
      self.currentUser.ref.removeValue()
    }
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
    }
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
}

// MARK: - UITEXTFIELD DELEGATE
extension EditUserViewController: UITextFieldDelegate {
  
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource METHODS
extension EditUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    return attributedString
  }
}
