//
//  FirebaseManager.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 09/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseManager {
  /// Entry point for singleton
  static let shared = FirebaseManager()
  /// Singleton initializer
  private init() {}
  
  /// Database reference for tours
  let visitRef: DatabaseReference = Database.database().reference().child("tours")
  /// Dabatabse user reference
  let userRef: DatabaseReference = Database.database().reference().child("users")
  
  /// Create a Visit Entity in the Firebase database
    func createVisit(user: String, date: String, title: String, id: String, imageUrl: String) {
    // Set new parameters
    let newVisit = ["user": user, "date": date, "title": title, "id": id, "imageUrl": imageUrl] as [String: Any]
    // update DB
    visitRef.childByAutoId().setValue(newVisit)
  }
  
  /// Load visit entities from Firebase
  func loadVisits(for currentUser: String, completionHandler:@escaping (_ visits: [Show]?)->()) {
    visitRef.observe(.value) { snapshot in
      var visitArray: [Show] = []
      var newItems = [Show]()
      for item in snapshot.children {
        let newVisit = Show(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newVisit, at: 0)
      }
      for item in newItems where item.user == currentUser {
        visitArray.insert(item, at: 0)
      }
      
      if visitArray.isEmpty {
        completionHandler(nil)
      }else {
        completionHandler(visitArray)
      }
    }
  }
  
  /// Updating method for visitis
  func updateVisit(user: String, key: String?, date: String, title: String, id: String, imageUrl: String) {
    // Set new parameters
     let parameters = ["user": user, "date": date, "title": title, "id": id, "imageUrl": imageUrl] as [String: Any]
    
    // update DB
    visitRef.child(key!).updateChildValues(parameters)
  }
  
  
  /// This function delete a visit from Firebase Database
  func deleteVisit (_ visit: Show) {
    guard let ref = visit.ref else { return}
    ref.removeValue()
  }
  
  /// Create a Visit Entity in the Firebase database
  func createUser(username: String, lastName: String, firstName: String, date: String, password: String, authorization: Int) {
    // Set new parameters
    let newUser = ["username": username, "lastName": lastName, "firstName": firstName, "date": date, "password": password, "authorization": authorization] as [String: Any]
    // update DB
    userRef.childByAutoId().setValue(newUser)
  }
  
  /// Load visit entities from Firebase
  func loadUsers(for currentUser: String, completionHandler:@escaping (_ users: [User]?)->()) {
    userRef.observe(.value) { snapshot in
      var userArray: [User] = []
      var newItems = [User]()
      for item in snapshot.children {
        let newUser = User(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newUser, at: 0)
      }
      for item in newItems where item.username == currentUser {
        userArray.insert(item, at: 0)
      }
      
      if userArray.isEmpty {
        completionHandler(nil)
      }else {
        completionHandler(userArray)
      }
    }
  }
  
  /// Updating User method
  func updateUser(username: String, key: String?, lastName: String, firstName: String, date: String, password: String, authorization: Int) {
    // Set new parameters
    let parameters = ["username": username, "lastName": lastName, "firstName": firstName, "date": date, "password": password, "authorization": authorization] as [String: Any]
    
    // update DB
    visitRef.child(key!).updateChildValues(parameters)
  }
  
  /// This function delete a user from Firebase Database
  func deleteUser (_ user: User) {
    guard let ref = user.ref else { return}
    ref.removeValue()
  }
}
