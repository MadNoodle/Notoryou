//
//  LoginViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 11/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  
  var currentUser: String = ""
  
  @IBOutlet weak var singInButton: UIButton!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var usernameField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    passwordField.delegate = self
    usernameField.delegate = self
    
    shouldDisplaySignInButton()
  }
  
  
  @IBAction func signIn(_ sender: UIButton) {
    if usernameField.text != "" && passwordField.text != "" {
      Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
        if error != nil {
          UserAlert.show(title: "Sorry", message: "This user is not allowed to access", controller: self)
        } else {
          if let usr = user {
            // store in user default
            self.currentUser = usr.user.email!
            
            // present main controller
            let homeVc = HomeViewController()
            homeVc.delegate = self
            let addVc = AddViewController()
            addVc.delegate = self
            let nav = UINavigationController(rootViewController: homeVc)
            self.present(nav, animated: true)
          }
        }
        
      }
    }
    else {
      UserAlert.show(title: "Sorry", message: "Please enter informations", controller: self)
    }
    
  }
  
  fileprivate func shouldDisplaySignInButton() {
    singInButton.layer.borderColor = UIColor.white.cgColor
    singInButton.layer.borderWidth = 2.0
    singInButton.layer.cornerRadius = 5
    singInButton.layer.masksToBounds = true
  }
  

}


extension LoginViewController: UserLoggedDelegate {
  
  
  func sendUser() -> String {
    return currentUser
  }
  
  
}
extension LoginViewController: UITextFieldDelegate {
  
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

