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



  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()

    urlTextField.delegate = self
    titleTextField.delegate = self
        // Do any additional setup after loading the view.
    }

  @IBOutlet weak var imageView: UIImageView!
  
  @IBAction func AddVisit(_ sender: UIButton) {
    var newShow: Show?
    
    if urlTextField.text != nil {
//      let imageUrl = URLParser.shared.parseURL(url: urlTextField.text!)
//      newShow = Show(title: titleTextField.text!, url: urlTextField.text!, imageName: "")
      let requestUrl = "https://my.matterport.com/api/v1/player/models/\(urlTextField.text!)/thumb"
      print(requestUrl)
      imageView.sd_setImage(with: URL(string: requestUrl), placeholderImage: #imageLiteral(resourceName: "logo_nty"))
      imageView.sd_setShowActivityIndicatorView(true)
      imageView.sd_setIndicatorStyle(.gray)
    }
    //print(newShow?.title)
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
