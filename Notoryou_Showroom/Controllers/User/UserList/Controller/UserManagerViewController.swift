//
//  UserManagerViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 14/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import FirebaseAuth
import InteractiveSideMenu

/// The controller allows the user to manage users
class UserManagerViewController: UIViewController, SideMenuItemContent {
  
  // MARK: - PROPERTIES
  /// RefreshController for tableView
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    refreshControl.tintColor = .white
    return refreshControl
  }()
  
  /// Array to store and retrieve users from database
  var users = [User]()
  
  // MARK: - OUTLETS
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString("Admin panel", comment: "")
    
    // TableView setup
    self.tableView.addSubview(self.refreshControl)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    let nib = UINib(nibName: "UserCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: "cellId")
    
    // NavigationBar Setup
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
    self.navigationItem.rightBarButtonItem =  addButton
    let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .done, target: self, action: #selector(showMenu))
    self.navigationItem.leftBarButtonItems = [menuButton]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // load users
    FirebaseManager.shared.loadUsers { (result, error) in
      if error != nil {
        UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
      }
      self.users = result!
      // refresh tableView
      self.tableView.reloadData()
    }
  }
  
  // MARK: - SELECTORS
  
  /// Add a new user button
  @objc func addUser() {
    let createUserVc = AddUserViewController()
    self.navigationController?.pushViewController(createUserVc, animated: true)
    
  }
  
  /// Display Menu
  @objc func showMenu() {
    showSideMenu()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Delegate
extension UserManagerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? UserCell
    // display username
    cell?.email.text = users[indexPath.row].email
    cell?.username.text = "\(users[indexPath.row].firstName!) \(users[indexPath.row].lastName!)"
    // display access level
    switch users[indexPath.row].authorization {
    case 0:
      cell?.access.text = NSLocalizedString("Administrator", comment: "")
    case 1:
      cell?.access.text = NSLocalizedString("Registered user", comment: "")
    case 2:
      cell?.access.text = NSLocalizedString("Visitor", comment: "")
    default:
      break
    }
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let editUserVc = EditUserViewController()
    // Edit user if selected
   editUserVc.currentUser = users[indexPath.row]
    self.navigationController?.pushViewController(editUserVc, animated: true)
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    //Load database for user and public
    DispatchQueue.main.async {
      FirebaseManager.shared.loadUsers { (results, error) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        self.users = results!
      }
    }
    self.tableView.reloadData()
    refreshControl.endRefreshing()
  }
  
}
