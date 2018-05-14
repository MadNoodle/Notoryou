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
import FirebaseStorage

class FirebaseManager {
  /// Entry point for singleton
  static let shared = FirebaseManager()
  /// Singleton initializer
  private init() {}
  
  /// Database reference for tours
  let visitRef: DatabaseReference = Database.database().reference().child("tours")
  /// Dabatabse user reference
  let userRef: DatabaseReference = Database.database().reference().child("user")
  
  /// Create a Visit Entity in the Firebase database
  func createVisit(user: String, date: String, title: String, id: String, imageUrl: String, visibility: Int) {
    // Set new parameters
    let newVisit = ["user": user, "date": date, "title": title, "id": id, "imageUrl": imageUrl, "visibilty": visibility] as [String: Any]
    // update DB
    visitRef.childByAutoId().setValue(newVisit)
  }
  
  /// Load visit entities from Firebase
  func loadVisits(for currentUser: String, completionHandler:@escaping (_ visits: [Show]?)->()) {
    visitRef.observe(.value) { snapshot in
      var visitArray = [Show]()
      var newItems = [Show]()
      
      // load all visitis
      for item in snapshot.children {
        let newVisit = Show(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newVisit, at: 0)
      }
      
      // filter public visits
      for item in newItems where item.visibility == 2{
        visitArray.insert(item, at: 0)
      }
      
      // filter user visits
      for item in newItems where item.user == currentUser {
        visitArray.insert(item, at: 0)
        print("title \(item.title)")
      }
      
      // filter duplicates
      visitArray = visitArray.filterDuplicates {$0.key == $1.key && $0.key == $1.key}
      
     // return array
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
   
      visitRef.observe(.value) { (snapshot) in
        for item in snapshot.children {
          
          let show = Show(snapshot: (item as? DataSnapshot)!)
          if show.key == visit.key {
            self.visitRef.child(visit.key).removeValue()
          }
        }
      }
    }
  
  
  /// Create a Visit Entity in the Firebase database
  func createUser(username: String, lastName: String, firstName: String, date: String, password: String, authorization: Int) {
    
    // Set new parameters
    let newUser = ["username": username, "lastName": lastName, "firstName": firstName, "date": date, "password": password, "authorization": authorization] as [String: Any]
    
    // update DB
    userRef.childByAutoId().setValue(newUser)
  }
  
  /// Load visit entities from Firebase
  func loadUsers( completionHandler:@escaping (_ users: [User]?)->()) {
    userRef.observe(.value) { snapshot in
      var userArray: [User] = []
      // load data from firebase
      for item in snapshot.children {
        let newUser = User(snapshot: (item as? DataSnapshot)!)
        userArray.insert(newUser, at: 0)
      }
      
      // return users
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
  
  let storageRef = Storage.storage().reference()
  
  func uploadImagePic(data: Data, completionhandler: @escaping (_ imageUrl: String) -> Void) {
    var imageUrl = ""
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    let uuid = UUID().uuidString
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.child(uuid).putData(data, metadata: metadata) {(_, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      self.storageRef.child(uuid).downloadURL(completion: { (url, error) in
        if error == nil {
          if let downloadUrl = url {
            // Make you download string
            imageUrl = downloadUrl.absoluteString
            
          }
        } else {
          // Do something if error
        }
      completionhandler(imageUrl)})
    }
    
    uploadTask.observe(.progress) { snapshot in
      // Upload reported progress
      let percentComplete = 1000.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
      print(percentComplete)
    }
    
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        switch StorageErrorCode(rawValue: error.code)! {
        case .objectNotFound:
          
          print("File doesn't exist")
          
        case .unauthorized:
          print("User doesn't have permission to access file")
          
        case .cancelled:
          print("User canceled the upload")
          
        case .unknown:
          // Unknown error occurred, inspect the server response
          break
        default:
          // A separate error occurred. This is a good place to retry the upload.
          break
        }
      }
    }
  }
}
