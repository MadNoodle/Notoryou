//
//  Container.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import InteractiveSideMenu
import FirebaseAuth

/// Container Controller to display the side Menu.
/// To ass a new menu item addd a new content controller
class Container: MenuContainerViewController {
  
  // MARK: - PROPERTIES
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    let screenSize: CGRect = UIScreen.main.bounds
    self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 2)
    
    // Instantiate menu view controller by identifier
    self.menuViewController = Menu()
    
    // Gather content items controllers
    self.contentViewControllers = contentControllers()
    
    // Select initial content controller. It's needed even if the first view controller should be selected.
    self.selectContentViewController(contentViewControllers.first!)
    
    self.currentItemOptions.cornerRadius = 10.0
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    // Options to customize menu transition animation.
    var options = TransitionOptions()
    
    // Animation duration
    options.duration = size.width < size.height ? 0.4 : 0.6
    
    // Part of item content remaining visible on right when menu is shown
    options.visibleContentWidth = size.width / 6
    self.transitionOptions = options
  }

   // MARK: - MENU METHODS
  
  /// This methods gather all menu controllers to create links
  ///
  /// - Returns: [UIViewControllers]
  private func contentControllers() -> [UIViewController] {
    var contentList = [UIViewController]()
    // add controllers in menu and inject them in navigation Controller
    let homeVc = HomeViewController()
    let nav1 = UINavigationController(rootViewController: homeVc)
    let userVc = UserManagerViewController()
    let nav2 = UINavigationController(rootViewController: userVc)
    let myToursVc = MyToursController()
    let nav3 = UINavigationController(rootViewController: myToursVc)
    let resetVc = ResetViewController()
    let nav4 = UINavigationController(rootViewController: resetVc)
    contentList.append(nav1)
    contentList.append(nav2)
    contentList.append(nav3)
    contentList.append(nav4)
    return contentList
  }
  /// Logout method to remove firebase current logged user
  func logOut() {
    UserDefaults.standard.set("", forKey: "currentUser")
    // Instantiate login Vc
    let loginVc = LoginViewController()
    let firebaseAuth = Auth.auth()
    do {
      // Signout and sends to login cntroller
      try firebaseAuth.signOut()
      self.dismiss(animated: true, completion: nil)
      UIApplication.shared.keyWindow?.rootViewController = loginVc
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    
  }
}
