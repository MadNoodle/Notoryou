//
//  Menu.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class Menu: MenuViewController {
  
  // MARK: - PROPERTIES
  /// Currently logged user in user Defaults
  var currentUser = ""
  /// Currently logged user in firebase
  var loggedUser: User!
  /// authorization level for user
  var author: (String, Int) = ("registered", 0)

  // MARK: - OUTLETS
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!
  
  // MARK: - LIFECYCLE METHODS 
  override func viewDidLoad() {
        super.viewDidLoad()

    // load current user
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
      handleAuthorizationLevel(for: currentUser)
      shouldLoadMenuItems()
    }
   
    
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    
  }
  // MARK: - METHODS
  /// Load items in menu tableView
  fileprivate func shouldLoadMenuItems() {
    // initialize menu
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "MenuCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "cellId")
  }
  
  /// This methods check which authorization level the current logged user have
  fileprivate func handleAuthorizationLevel(for user: String) {
    // Check logged user authorization
    FirebaseManager.shared.loadUsers { (users, error) in
      if error != nil {
        UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
      }
      for usr in users! where usr.email == user {
        self.usernameLabel.text = "\(usr.firstName!) \(usr.lastName!)"
        switch usr.authorization {
        case 0:
          self.author = ("Administrator",  0)
        case 1:
          self.author = ("Registered user", 1)
        case 2:
          self.author = ("Visitor", 2)
          
        default:
          break
        }
       
     
        self.roleLabel.text = NSLocalizedString(self.author.0, comment: "")
      }
      // assign the user role label his current granted access
      
    }
  }
  
  /// Allow the menu to display a controller when a menuCell is selected
  ///
  /// - Parameter index: Int index of the controller tto display in container Content Controllers
  func showController(_ index: Int) {
    guard let menuContainerViewController = self.menuContainerViewController else { return }
    let contentController = menuContainerViewController.contentViewControllers[index]
    menuContainerViewController.selectContentViewController(contentController)
    menuContainerViewController.hideSideMenu()
  }
}

// MARK: - TABLEVIEW DELEGATE METHODS
extension Menu: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
 
    switch indexPath.row {
    case 0 :
      showController(0)
    case 1 :
      showController(2)
    case 2 :
      guard let menuContainerViewController = self.menuContainerViewController as? Container else { return }
      menuContainerViewController.logOut()
      
    case 3:
      showController(1)
    default:
      break
      }
   
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MenuCell
    
    DispatchQueue.main.async {
      
      switch indexPath.row {
      case 0 :
        cell?.titleLabel.text = NSLocalizedString("Home", comment: "")
        cell?.icon.image = #imageLiteral(resourceName: "home ")
      case 1 :
        cell?.titleLabel.text = NSLocalizedString("My Tours", comment: "")
        cell?.icon.image = #imageLiteral(resourceName: "image ")
      case 2 :
        cell?.titleLabel.text = NSLocalizedString("Log out", comment: "")
        cell?.icon.image = #imageLiteral(resourceName: "minus_circle ")
      case 3:
        cell?.titleLabel.text = NSLocalizedString("User Management", comment: "")
        cell?.icon.image = #imageLiteral(resourceName: "profile ")
        
        print("Auth: \(self.author.1)")
        if self.author.1 != 0 {
          cell?.isHidden = true
          
        }
      
      default:
        break
      }
    }
    
    return cell!
  }

}
