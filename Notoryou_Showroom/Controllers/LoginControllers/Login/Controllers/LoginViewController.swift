//
//  LoginViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 11/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import FirebaseAuth
import Crashlytics

/// This controller handles the user login
class LoginViewController: UIViewController {
  
  // MARK: - PROPERTIES
  var currentUser: String = ""
  
  // MARK: - OUTLETS
  @IBOutlet weak var singInButton: UIButton!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var usernameField: UITextField!
  
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set up textfield delegation
    passwordField.delegate = self
    usernameField.delegate = self
    // display UI
    shouldDisplaySignInButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // check if user is already sign in and sends him directly to Home controller
    if Auth.auth().currentUser != nil {
      let container = Container()
      self.present(container, animated: true)
    }
  }
  
  // MARK: - ACTIONS
  @IBAction func signIn(_ sender: UIButton) {
    
    // test crashlytics # uncomment to make a test
    // Crashlytics.sharedInstance().crash()
    
    // check if the email adress correpond to email pattern
    guard let email = usernameField.text?.isValidEmailAddress() else { return}
    // Check if textfield is not empty
    if email && passwordField.text != "" {
      // Signin Firebase Auth
      Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("This user is not allowed to access", comment: ""), controller: self)
        } else {
          if let usr = user {
            // store in user default
            UserDefaults.standard.set(usr.user.email!, forKey: "currentUser")
            let container = Container()
            self.present(container, animated: true)
          }
        }
        
      }
    } else {
      // Display an alert if informations are not valid and user is not registered
      UserAlert.show(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("Please enter valid informations", comment: ""), controller: self)
    }
    
  }
  
  /// Present a controller to allow the user to reset his password
  ///
  /// - Parameter sender: UIButton
  @IBAction func handleForgottenPasswords(_ sender: UIButton) {
    let resetVc = ResetViewController()
    present(resetVc,animated:  true)
  }
  
  /// Customize Login button appearance
  fileprivate func shouldDisplaySignInButton() {
    singInButton.layer.borderColor = UIColor.white.cgColor
    singInButton.layer.borderWidth = 2.0
    singInButton.layer.cornerRadius = 5
    singInButton.layer.masksToBounds = true
  }

}

// MARK: - USERLOGGEDDELEGATE METHODS
extension LoginViewController: UserLoggedDelegate {
  ///
  /// Send back a user object
  ///
  /// - Returns: String the current user username
  func sendUser() -> String {
    return currentUser
  }
  
}

// MARK: - USERLOGGEDDELEGATE METHODS
extension LoginViewController: UITextFieldDelegate {
  
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

