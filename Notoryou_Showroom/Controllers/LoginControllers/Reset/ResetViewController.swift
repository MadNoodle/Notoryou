//
//  ResetViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import FirebaseAuth
import InteractiveSideMenu
class ResetViewController: UIViewController, SideMenuItemContent {
  
  // MARK: - OUTLETS
  @IBOutlet weak var resetEmail: CustomTextField!
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    // Add Menu Button
    let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .done, target: self, action: #selector(showMenu))
    self.navigationController?.navigationItem.leftBarButtonItems = [menuButton]
  }
  
  /// Menu button Selector
  @objc func showMenu() {
    showSideMenu()
  }
  
  
  // MARK: - ACTIONS
  @IBAction func reset(_ sender: UIButton) {
    // check if the text is not nil
    guard let email = resetEmail.text else { return}
    if email.isValidEmailAddress(){
    // Ask Firebase to send a reset password to this email address
    Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
      if error != nil{
        // Display an alert when reset fails
        let resetFailedAlert = UIAlertController(title: NSLocalizedString("Reset Failed", comment: ""), message: error!.localizedDescription, preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(resetFailedAlert, animated: true, completion: nil)
      }else {
        // Display alert to confirm email was sent
        let resetEmailSentAlert = UIAlertController(title: NSLocalizedString("Reset email sent successfully", comment: ""), message: NSLocalizedString("Check your email", comment: ""), preferredStyle: .alert)
        resetEmailSentAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
          self.dismiss(animated: true, completion: nil)
        }))
        self.present(resetEmailSentAlert, animated: true, completion: nil)
      }
    })} else {
      // check if the text conform to  email regex pattern
      UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please enter a valid email", comment: ""), controller: self)
    }
  }
  
  @IBAction func goBack(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
