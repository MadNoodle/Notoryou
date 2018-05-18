//
//  AddViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 09/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AlamofireImage

/// Controller to Add a new visit in database
class AddViewController: UIViewController {

  // MARK: - PROPERTIES
  
  /// Property to store access level for current visit
  var isPublic = 0
  /// Current loged user
  var currentUser = ""
  /// properties to show loader
  let blackView = UIView()
  let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  
  // MARK: - OUTLETS
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var previewTextField: UITextField!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var setPublicLabel: UILabel!
  @IBOutlet weak var thumbnailUrlLabel: UILabel!
  @IBOutlet weak var visitUrlLabel: UILabel!
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
        super.viewDidLoad()
      // load current user
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    titleLabel.text = NSLocalizedString("Title", comment: "")
    visitUrlLabel.text = NSLocalizedString("Immersive Tour Url", comment: "")
    thumbnailUrlLabel.text = NSLocalizedString("Thumbnail Url", comment: "")
    setPublicLabel.text = NSLocalizedString("Set public", comment: "")
    // delegation
    urlTextField.delegate = self
    titleTextField.delegate = self
    previewTextField.delegate = self
    
    // add save button
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(saveVisit))
    self.navigationItem.rightBarButtonItem = addButton
    }

  /// handles the privacy status of the currentVisit
  /// if public all users can see the visit else only admin and current user can see it
  /// - Parameter sender: switch
  @IBAction func setPublic(_ sender: UISwitch) {
    if sender.isOn {
      isPublic = 2
       // show alert to tell it will be visible by all users
       UserAlert.show(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("All users will access to this content", comment: ""), controller: self)
    } else {
      // set to private
      isPublic = 0
    }
  }
  
  /// CallBack function for save button that saves the visit in firebase
  @objc func saveVisit() {
    showLoader()
    // check required fields
    if titleTextField.text != "" && urlTextField.text != "" && previewTextField.text != "" {
      // resize Image to ligthen it
      guard let resizedImage = thumbnailView.image?.resize(to: 400) else { return}
      
        // Convert to data to store it in Firebase Storage
        guard let data = UIImagePNGRepresentation(resizedImage) else { return}
        FirebaseManager.shared.uploadImagePic(data: data, completionhandler: {(newUrl, error) in
          if error != nil {
            UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
          }
          // create saving time
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy MM dd"
          let saveDate = formatter.string(from: Date())
          
          // save object to firebase
          FirebaseManager.shared.createVisit(user: self.currentUser, date: saveDate, title: self.titleTextField.text!, id: self.urlTextField.text!, imageUrl: newUrl, visibility: self.isPublic) { (_, error) in
            if error != nil {
              UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
            } else {
              UserAlert.show(title: NSLocalizedString("Congratulations", comment: ""), message: NSLocalizedString("Your visit has been saved", comment: ""), controller: self)
              print("complete")
              self.hideLoader()
            }
          }
        })
    } else {
      // Show alert if all required fields are not fulffilled
      UserAlert.show(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please fulfill all required fields", comment: ""), controller: self)
    }
  }

  /// Self Documented
  fileprivate func showLoader() {
    // show spinner
    self.view.addSubview(indicator)
    indicator.frame = self.view.frame
    indicator.startAnimating()
  }
  
  /// Self documented
  fileprivate func hideLoader() {
    // hide loader
    self.indicator.stopAnimating()
    self.indicator.removeFromSuperview()
   
  }
}

// MARK: - UITEXTFIELD DELEGATE
extension AddViewController: UITextFieldDelegate {
  
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
    if textField.tag == 1 {
      guard let url = URL(string: previewTextField.text!) else { return true }
      thumbnailView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logonb"), options: [.progressiveDownload]) { (_, error, _, _) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please enter a valid url", comment: ""), controller: self)
        }
      }
    }
    return (true)
  }
}
