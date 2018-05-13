//
//  Shows.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {
  var username: String!
  var lastName: String!
  var firstName: String!
  var email: String!
  var password: String!
  var authorization: Int!
  var ref: DatabaseReference!
  var key: String!
  
  // Init User from values
  init(username: String, lastName: String, firstName: String, date: String, password: String, authorization: Int){
    self.ref = Database.database().reference()
    self.username = username
    self.lastName = lastName
    self.firstName = firstName
    self.password = password
    self.authorization = authorization
    self.key = ""
  }
  
  // Init User from Firebase Snapshot values
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String: Any] else { return}
    self.ref = snapshot.ref
    self.username = dict["username"] as? String
    self.lastName = dict["lastName"] as? String
    self.firstName = dict["firstName"] as? String
    self.password = dict["password"] as? String
    self.authorization = dict["authorization"] as? Int
  self.key = snapshot.key
  }

}
