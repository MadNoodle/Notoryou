//
//  PlayerViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import WebKit

class PlayerViewController: UIViewController,WKUIDelegate, WKNavigationDelegate {
  var url = ""
  @IBOutlet weak var wkView: WKWebView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    wkView.uiDelegate = self
    
    let myURL = URL(string: url)
    let myRequest = URLRequest(url: myURL!)
    wkView.load(myRequest)
    }

  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      //webView.load(navigationAction.request)
      UIApplication.shared.open(navigationAction.request.url!, options: [:])
    }
    return nil
  }


}
