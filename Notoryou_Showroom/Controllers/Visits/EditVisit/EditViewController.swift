//
//  EditViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 13/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Controllers that allows user to edit an existing visit
class EditViewController: UIViewController {
  
  // MARK: - PROPERTIES
  
  /// Property to store access level for current visit
  var isPublic = 0
  /// Current loged user
  var currentUser = ""
  /// Show displayed
  var currentShow: Show!
  /// properties to show loader
  let blackView = UIView()
  let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  
  // MARK: - OUTLETS
  
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var previewTextField: UITextField!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  
  // MARK: - LIFECYCLEMETHODS
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // load current user
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    // add save button
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(title: NSLocalizedString("update", comment: ""), style: .done, target: self, action: #selector(updateVisit))
    self.navigationItem.rightBarButtonItem = addButton
    
    // Populate fields
    titleTextField.text = currentShow.title
    urlTextField.text = currentShow.url
    previewTextField.text = currentShow.imageName
    loadImage()
    
    // delegation
    urlTextField.delegate = self
    titleTextField.delegate = self
    previewTextField.delegate = self
    
  }
  
  // MARK: - SELECTORS
  
  /// Callback selector method for navigation bar button
  @objc func updateVisit() {
    // check required fields
    if titleTextField.text != "" && urlTextField.text != "" && previewTextField.text != "" && thumbnailView.image != nil {
      
      // resize image to lower size in Mb
      guard let resizedImage = thumbnailView.image?.resize(to: 400) else { return}
      
      // Convert to Data for uplaod
      guard let data = UIImagePNGRepresentation(resizedImage) else { return}
      
      // Upload in firebase Storage
      FirebaseManager.shared.uploadImagePic(data: data, completionhandler:  { (newUrl, error) in
        
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        // create saving time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let saveDate = formatter.string(from: Date())
        let showKey = self.currentShow.key
        
        // update Visits image
        FirebaseManager.shared.updateVisit(user: self.currentUser, key: showKey, date: saveDate, title: self.titleTextField.text!, id: self.urlTextField.text!, imageUrl: newUrl) {(_, error) in
          if error != nil {
            UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
          }
          UserAlert.show(title: NSLocalizedString("Congratulations", comment: ""), message: NSLocalizedString("Your visit has been updated", comment: ""), controller: self)
        }
      })
      
    } else {
      UserAlert.show(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please fulffil all the required fields", comment: ""), controller: self)
    }
  }
  
  /// This methods allows to download asynchroneously the image and cache it via SDWebImage
  func loadImage() {
    guard let url = URL(string:previewTextField.text!) else { return }
    // downlad and cache image
    thumbnailView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logonb"), options: [.progressiveDownload]) { (image, error, cache, url) in
      // display error if needed
      if error != nil {
        UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please enter a valid url", comment: ""), controller: self)
      }
    }
  }
}

// MARK: - UITEXTFIELD DELEGATE
extension EditViewController: UITextFieldDelegate {
  
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
      loadImage()
    }
    return (true)
  }
}
