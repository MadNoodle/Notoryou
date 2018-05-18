//
//  HomeViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

import FirebaseAuth
import MessageUI
import InteractiveSideMenu

class HomeViewController: UIViewController, VisitDelegate, UserLoggedDelegate, SideMenuItemContent {
  func sendUser() -> String {
    return currentUser
  }
  

  // MARK: - PROPERTIES
  
  var shows = [Show]()
  var currentShow: Show?
  var showToExport = [(String,String)]()
  let blackView = UIView()
  let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  var currentUser = ""
  var author = 2
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(handleRefresh),
                             for: UIControlEvents.valueChanged)
    refreshControl.tintColor = .white
    return refreshControl
  }()
  
  // MARK: - OUTLETS
  @IBOutlet weak var tableView: UITableView!
  // MARK: - LIFECYCLE METHODS
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Tours"

    // load current user
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    
    FirebaseManager.shared.loadUsers { (users, error) in
      if error != nil {
        UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
      }
      for usr in users! where usr.email == self.currentUser {
        print(usr.authorization!)
        guard let access = usr.authorization else { return}
        self.author = access
      }
    }
    shouldSetUpUI()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    showLoader()
    
    //Load database for user and public
    DispatchQueue.main.async {
      FirebaseManager.shared.loadVisits(for: self.currentUser) { (result, error) in
        if error != nil {
           UserAlert.show(title: NSLocalizedString("Error", comment: ""), message:error!.localizedDescription , controller: self)
        }
        if result != nil{
          self.shows = result!
          self.tableView.reloadData()
          self.hideLoader()
        } else {
         UserAlert.show(title: NSLocalizedString("sorry", comment: ""), message:NSLocalizedString("There is no tour available for you", comment: "") , controller: self)
        }
      }
    }
  
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
      self.navigationItem.rightBarButtonItems![1].image = #imageLiteral(resourceName: "share ")
      if showToExport.count == 0 {
        UserAlert.show(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please choose a visit to share", comment: ""), controller: self)
      } else {
        shouldDisplayChoice()
      }
      
    }
    else
    {
      self.tableView.isEditing = true
      self.navigationItem.rightBarButtonItems![1].image = #imageLiteral(resourceName: "send ")
    }
  }
  
  @objc func showMenu() {
    showSideMenu()
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    //Load database for user and public
    DispatchQueue.main.async {
      FirebaseManager.shared.loadVisits(for: self.currentUser) { (result, error) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        if result != nil{
          self.shows = result!
          self.tableView.reloadData()
          self.hideLoader()
        } else {
          UserAlert.show(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("There is no tour available for you", comment: ""), controller: self)
        }
      }
    }
    self.tableView.reloadData()
    refreshControl.endRefreshing()
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
    self.tableView.addSubview(self.refreshControl)
    // Nav Controller setup
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShow))
    
    let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share "), style: .done, target: self, action: #selector(showEditing))
    self.navigationItem.rightBarButtonItems = [addButton, rightButton]
    
    let logOutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .done, target: self, action: #selector(showMenu))
    
    self.navigationItem.leftBarButtonItems = [logOutButton]
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
  
  fileprivate func shouldDisplayChoice() {
    let sendAction = UIAlertAction(title: NSLocalizedString("Send email", comment: ""), style: .default) { (action) in
      self.sendMail()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
      
    }
    let alertController = UIAlertController(title: "Confirm", message: NSLocalizedString("Do you want to share these links?", comment: ""), preferredStyle: .actionSheet)
    alertController.addAction(sendAction)
    alertController.addAction(cancelAction)
    present(alertController, animated:  true)
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
      cell?.thumbnail.load(urlString: shows[indexPath.row].imageName)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentShow = shows[indexPath.row] 
    let playerVc = PlayerViewController()
    playerVc.url = currentShow.url
    playerVc.showRef = currentShow.ref
    playerVc.currentShow = currentShow
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
  
  
  func sendVisit() -> Show? {
    guard let show = currentShow else { return nil }
    return show
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
   
    mailComposerVc.setSubject(NSLocalizedString("Notoryou sends you some links", comment: ""))
    let body = generateMailBody(from: showToExport)
    mailComposerVc.setMessageBody(body, isHTML: true)
    
    return mailComposerVc
  }
  
  func showSendMailErrorAlert() {
    UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There was an error while sending mail", comment: ""), controller: self)
  }
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}


