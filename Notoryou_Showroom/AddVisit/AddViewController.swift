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

class AddViewController: UIViewController, UITextFieldDelegate {

  var isPublic = 0
  var currentUser = ""

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
       UserAlert.show(title: "Attention", message: "Tous les utilisateurs de Notoryou pourrons accèder à votre visite", controller: self)
    } else {
      // set to private
      isPublic = 0
    }
  }
  
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0,y: 0,width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  /// CallBack function for save button that saves the visit in firebase
  @objc func saveVisit() {
   print("saving")
    showLoader()
    // check required fields
    if titleTextField.text != "" && urlTextField.text != "" && previewTextField.text != "" && thumbnailView.image != nil {
      
      guard let resizedImage = thumbnailView.image?.resize(to: 400) else { return}
      
        
        guard let data = UIImagePNGRepresentation(resizedImage) else { return}
        FirebaseManager.shared.uploadImagePic(data: data, completionhandler:  { (newUrl) in
          // create saving time
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy MM dd"
          let saveDate = formatter.string(from: Date())
          
          // save object to firebase
          FirebaseManager.shared.createVisit(user: self.currentUser, date: saveDate, title: self.titleTextField.text!, id: self.urlTextField.text!, imageUrl: newUrl, visibility: self.isPublic)
          UserAlert.show(title: "Bravo", message: "Votre visite a été sauvegardée", controller: self)
          print("complete")
          self.hideLoader()
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
      guard let url = URL(string:previewTextField.text!) else { return true }
      thumbnailView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logonb"), options: [.progressiveDownload]) { (image, error, cache, url) in
        if error != nil {
          UserAlert.show(title: "Erreur", message: "L'url fournie n'est pas valide", controller: self)
        }
      }
    }
    return (true)
  }
  
  fileprivate func showLoader() {

    // show spinner
    self.view.addSubview(indicator)
    indicator.frame = self.view.frame
    indicator.startAnimating()
  }
  
  fileprivate func hideLoader() {
    // hide loader
    self.indicator.stopAnimating()
    self.indicator.removeFromSuperview()
   
  }


}
