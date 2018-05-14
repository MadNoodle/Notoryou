//
//  UserManagerViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 14/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserManagerViewController: UIViewController {

  var users = [User]()
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()

      tableView.delegate = self
      tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    
    self.navigationController?.navigationBar.isTranslucent = false
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShow))
    
    self.navigationItem.rightBarButtonItem =  addButton
 }
  
  override func viewWillAppear(_ animated: Bool) {
    FirebaseManager.shared.loadUsers { (result) in
      self.users = result!

      self.tableView.reloadData()
    }
  }
  
  @objc func addShow() {
   
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
  
}


extension UserManagerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    cell.textLabel?.text = users[indexPath.row].email
    cell.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
    cell.textLabel?.textColor = .white
    return cell
  }
}
