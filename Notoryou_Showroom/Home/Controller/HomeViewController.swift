//
//  HomeViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import MessageUI

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var shows = [Show]()
  var currentShow: Show?
  var showToExport = [(String,String)]()
  let blackView = UIView()
  let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  var currentUser = ""
  var delegate: UserLoggedDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Tours"
    // grab current logged user
    if delegate != nil {
      currentUser = delegate.sendUser()
    } else {
      UserAlert.show(title: "Error", message: "logging error", controller: self)
    }
    shouldSetUpUI()
    showLoader()
    
    //Load database for user and public
    DispatchQueue.main.async {
      FirebaseManager.shared.loadVisits(for: self.currentUser) { (result) in
        if result != nil{
          self.shows = result!
          self.tableView.reloadData()
          self.hideLoader()
        } else {
          UserAlert.show(title: "Sorry", message: "There is no tour available for you", controller: self)
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {

    tableView.reloadData()
  }
  
  // MARK: - CALLBACK METHODS
  
  // CallBack function for navBAr button
  @objc func addShow() {
    let addVc = AddViewController()
    self.navigationController?.pushViewController(addVc, animated: true)
  }
  
  
  
  // Set editing Mode
  @objc func showEditing(sender: UIBarButtonItem)
  {
    if(self.tableView.isEditing == true)
    {
      self.tableView.isEditing = false
      self.navigationItem.rightBarButtonItems![1].title = "Select"
      sendMail()
    }
    else
    {
      self.tableView.isEditing = true
      self.navigationItem.rightBarButtonItems![1].title = "Share"
      
      
    }
  }
  
  @objc func logOut() {
    let loginVc = LoginViewController()
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      present(loginVc, animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  

  // MARK: - UI METHODS
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  fileprivate func shouldSetUpUI() {
    self.setNeedsStatusBarAppearanceUpdate()
    // Register cell classes
    let nib = UINib(nibName: "Showcell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "myCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelectionDuringEditing = false
    
    // Nav Controller setup
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShow))
   
    let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showEditing))
    self.navigationItem.rightBarButtonItems = [addButton, rightButton]
    
    let logOutButton = UIBarButtonItem(title: "log out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
    self.navigationItem.leftBarButtonItem = logOutButton
  }
  
  fileprivate func showLoader() {
    // add black bg
    self.view.addSubview(blackView)
    blackView.layer.opacity = 1
    blackView.frame = self.view.frame
    blackView.backgroundColor = .black
    // show spinner
    self.view.addSubview(indicator)
    indicator.frame = self.view.frame
    indicator.startAnimating()
  }
  fileprivate func hideLoader() {
    // hide loader
    UIView.animate(withDuration: 0.5, animations: {
      self.blackView.layer.opacity = 0
    })
    self.indicator.stopAnimating()
    self.indicator.removeFromSuperview()
    self.blackView.removeFromSuperview()
  }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shows.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? Showcell
    // load title
    cell?.showTitle.text = shows[indexPath.row].title
    // load image
    DispatchQueue.main.async {
      cell?.thumbnail.sd_setImage(with: URL(string:self.shows[indexPath.row].imageName) , placeholderImage: #imageLiteral(resourceName: "logo_nty"), options: [.continueInBackground, .progressiveDownload])
    }

    
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentShow = shows[indexPath.row] 
    let playerVc = PlayerViewController()
    playerVc.url = currentShow.url
    self.navigationController?.pushViewController(playerVc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .insert
  }


  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .insert {
      if let currentShowUrl = shows[indexPath.row].url {
        if let currentShowName = shows[indexPath.row].title {
          let export = (currentShowUrl, currentShowName)
      showToExport.append(export)
      
        }
      }
    }
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .black
  }


}

extension HomeViewController: MFMailComposeViewControllerDelegate {
  
  
  /// Opens Mail app to send the list f selected links
  fileprivate func sendMail() {
    let mailCompVc = configureMailComposerViewController()
    if MFMailComposeViewController.canSendMail() {
      self.present(mailCompVc,animated: true)
    } else {
      self.showSendMailErrorAlert()
    }
  }
  
  func generateMailBody(from array: [(String,String)]) -> String {
    var body = ""
    var links = [String]()
    for item in array {
      // generate a html link
      let link = "<a href=\"\(item.0)\">\(item.1)</a><br><br>"
      links.append(link)
    }
    body = links.joined(separator: "")
    return body
  }
  
  func configureMailComposerViewController() -> MFMailComposeViewController {
    let mailComposerVc = MFMailComposeViewController()
    mailComposerVc.mailComposeDelegate = self
    mailComposerVc.setToRecipients(["mjanneau@gmail.com"])
    mailComposerVc.setSubject("Notoryou sends you some links")
    let body = generateMailBody(from: showToExport)
    mailComposerVc.setMessageBody(body, isHTML: true)
    
    return mailComposerVc
  }
  
  func showSendMailErrorAlert() {
    UserAlert.show(title: "Error", message: "There was an error while sending mail", controller: self)
  }
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
