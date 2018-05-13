//
//  EditViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 13/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {

  var isPublic = 0
  var currentUser = ""
  var currentShow: Show!

  let blackView = UIView()
  let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var previewTextField: UITextField!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      // load current user
      if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
        currentUser = user
      }
        titleTextField.text = currentShow.title
        urlTextField.text = currentShow.url
        previewTextField.text = currentShow.imageName
        loadImage()
      
      // delegation
      urlTextField.delegate = self
      titleTextField.delegate = self
      previewTextField.delegate = self
      
      
      // add save button
      self.navigationController?.navigationBar.isTranslucent = false
      let addButton = UIBarButtonItem(title: "update", style: .done, target: self, action: #selector(updateVisit))
      self.navigationItem.rightBarButtonItem = addButton
    }

    
  @objc func updateVisit() {
    print("updating")
 
    // check required fields
    if titleTextField.text != "" && urlTextField.text != "" && previewTextField.text != "" && thumbnailView.image != nil {
      
      guard let resizedImage = thumbnailView.image?.resize(to: 400) else { return}
      
      
      guard let data = UIImagePNGRepresentation(resizedImage) else { return}
      FirebaseManager.shared.uploadImagePic(data: data, completionhandler:  { (newUrl) in
        // create saving time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let saveDate = formatter.string(from: Date())
        let showKey = self.currentShow.key
        // save object to firebase
        FirebaseManager.shared.updateVisit(user: self.currentUser, key: showKey, date: saveDate, title: self.titleTextField.text!, id: self.urlTextField.text!, imageUrl: newUrl)
        UserAlert.show(title: "Bravo", message: "Votre visite a été mise à jour", controller: self)
      })
      
    } else {
      UserAlert.show(title: "Attention", message: "Veuillez remplir tous les champs", controller: self)
    }
  }
  
  
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
  
  func loadImage() {
    guard let url = URL(string:previewTextField.text!) else { return }
    thumbnailView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logonb"), options: [.progressiveDownload]) { (image, error, cache, url) in
      if error != nil {
        UserAlert.show(title: "Erreur", message: "L'url fournie n'est pas valide", controller: self)
      }
    }
  }
}
