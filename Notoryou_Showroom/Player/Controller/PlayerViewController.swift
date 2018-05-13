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

class PlayerViewController: UIViewController{
  
  var url = ""
  var showRef: DatabaseReference!
  
  @IBOutlet weak var wkView: WKWebView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    
    // Customize Navigation bar
    self.navigationController?.navigationBar.isTranslucent = false
    let editButton = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editVisit))
    
    let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete "), style: .done, target: self, action: #selector(deleteVisit))
    self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
    
    shouldDisplayVisit()
    }

 
  
  /// load visit in WKWebView
  fileprivate func shouldDisplayVisit() {
    wkView.uiDelegate = self
    let myURL = URL(string: url)
    let myRequest = URLRequest(url: myURL!)
    wkView.load(myRequest)
  }
  
  /// Callback function to edit the current visit
  @objc func editVisit() {
    print("edit Visit")
  }
  
  /// Callback function to delete the current visit
  @objc func deleteVisit() {
    
    let alertController = UIAlertController(title: "Attention", message: "Vous êtes sur le point d'effacer cette visite. Cette opération est irréversible", preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: "Supprimer", style: .default) { (_) in
      print("delete")
//      if self.delegate != nil {
//        guard let show = self.delegate?.currentShow else { return}
//        FirebaseManager.shared.deleteVisit(show)
//      }
//
      // Send user back to collection
      let homeVc = HomeViewController()
      self.navigationController?.pushViewController(homeVc, animated: true)
      
      // delete
    
      self.showRef.removeValue()
      
      
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
    }
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
    
  }
}

extension PlayerViewController:WKUIDelegate, WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      UIApplication.shared.open(navigationAction.request.url!, options: [:])
    }
    return nil
  }
}
