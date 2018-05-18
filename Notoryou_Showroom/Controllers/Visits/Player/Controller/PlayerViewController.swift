//
//  PlayerViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase

/// Controllers that displays the immersive visit
class PlayerViewController: UIViewController {
  
  // MARK: - PROPERTIES
  /// Current displayed visit
  var currentShow: Show!
  /// Property to store the immersive visit url
  var url = ""
  /// Show Ref property
  var showRef: DatabaseReference!
  
  // MARK: - OUTLETS
  @IBOutlet weak var wkView: WKWebView!
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
        super.viewDidLoad()
    // Customize Navigation bar
    self.navigationController?.navigationBar.isTranslucent = false
    let editButton = UIBarButtonItem(title: NSLocalizedString("edit", comment: ""), style: .plain, target: self, action: #selector(editVisit))
    
    let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete "), style: .done, target: self, action: #selector(deleteVisit))
    self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
    
    shouldDisplayVisit()
    }

  // MARK: - UI METHODS
  /// load visit in WKWebView
  fileprivate func shouldDisplayVisit() {
    wkView.uiDelegate = self
    let myURL = URL(string: url)
    let myRequest = URLRequest(url: myURL!)
    wkView.load(myRequest)
  }
  
  // MARK: - SELECTORS
  
  /// Callback function to edit the current visit
  @objc func editVisit() {
   let editVc = EditViewController()
   editVc.currentShow = currentShow
    self.navigationController?.pushViewController(editVc, animated: true)
  }
  
  /// Callback function to delete the current visit
  @objc func deleteVisit() {
    
    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Warning you are about to permanently delete this visit", comment: ""), preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default) { (_) in

      // Send user back to collection
      let homeVc = HomeViewController()
      self.navigationController?.pushViewController(homeVc, animated: true)
      
      // delete
      self.showRef.removeValue()
    }
    
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in }
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
    
  }
}

// MARK: - WKUIDelegate, WKNavigationDelegate
extension PlayerViewController: WKUIDelegate, WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      UIApplication.shared.open(navigationAction.request.url!, options: [:])
    }
    return nil
  }
}
