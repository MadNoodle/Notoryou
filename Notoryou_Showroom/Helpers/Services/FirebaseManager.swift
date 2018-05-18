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
import FirebaseAuth

/// This class handles all the communication and requests for Firebase database Auth and storage
class FirebaseManager {
  /// Entry point for singleton
  static let shared = FirebaseManager()
  /// Singleton initializer
  private init() {}
  
  /// Database reference for tours
  let visitRef: DatabaseReference = Database.database().reference().child("tours")
  /// Dabatabse user reference
  let userRef: DatabaseReference = Database.database().reference().child("user")
  /// Database for usernames to check for duplicates
  let usernameRef: DatabaseReference = Database.database().reference().child("usernames")
  /// Firebase Storage Reference for picture storage
  let storageRef = Storage.storage().reference()
  
  /// Create a Visit Entity in the Firebase database
  func createVisit(user: String, date: String, title: String, id: String, imageUrl: String, visibility: Int, completion: @escaping (_ status: String, _ error: Error?) -> Void) {
    
    // Set new parameters
    let newVisit = ["user": user, "date": date, "title": title, "id": id, "imageUrl": imageUrl, "visibilty": visibility] as [String: Any]
    // update DB
    
    visitRef.childByAutoId().setValue(newVisit) { (error, _) in
      if error != nil {
        completion("succes", nil)
      } else {
        completion("error", error)
      }
    }
    
  }
  
  /// Load visit entities from Firebase
  func loadVisits(for currentUser: String, completionHandler: @escaping (_ visits: [Show]?, _ error: Error?) -> Void) {
   
    visitRef.observe(.value) { (snapshot, error) in
      var visitArray = [Show]()
      var newItems = [Show]()
      
      if error != nil {
        completionHandler(nil, error as? Error)
      }
      
      // load all visitis
      for item in snapshot.children {
        let newVisit = Show(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newVisit, at: 0)
      }
      
      // filter public visits
      for item in newItems where item.visibility == 2 {
        visitArray.insert(item, at: 0)
      }
      
      // filter user visits
      for item in newItems where item.user == currentUser {
        visitArray.insert(item, at: 0)
      }
      
      // filter duplicates
      visitArray = visitArray.filterDuplicates {$0.key == $1.key && $0.key == $1.key}
      
     // return array
      if visitArray.isEmpty {
        completionHandler(nil, nil)
      } else {
        completionHandler(visitArray, nil)
      }
    }
  }
  
  /// Load visit entities from Firebase
  func loadMyVisits(for currentUser: String, completionHandler:@escaping (_ visits: [Show]?, _ error: Error?) -> Void) {
    visitRef.observe(.value) { (snapshot, error) in
      var visitArray = [Show]()
      var newItems = [Show]()
      
      if error != nil {
        completionHandler(nil, error as? Error)
      }
      // load all visitis
      for item in snapshot.children {
        let newVisit = Show(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newVisit, at: 0)
      }
    
      // filter user visits
      for item in newItems where item.user == currentUser {
        visitArray.insert(item, at: 0)
      }
      
      // filter duplicates
      visitArray = visitArray.filterDuplicates {$0.key == $1.key && $0.key == $1.key}
      
      // return array
      if visitArray.isEmpty {
        completionHandler(nil, nil)
      } else {
        completionHandler(visitArray, nil)
      }
    }
  }

  /// Updating method for visits
  func updateVisit(user: String, key: String?, date: String, title: String, id: String, imageUrl: String, completion: @escaping(_ status: String, _ error: Error?) -> Void) {
    
    // Set new parameters
     let parameters = ["user": user, "date": date, "title": title, "id": id, "imageUrl": imageUrl] as [String: Any]
    
    // update DB
    visitRef.child(key!).updateChildValues(parameters) { (error, _) in
      if error != nil {
        completion("error", error)
      } else {
        completion("success", nil)
      }
    }
  }
  
  /// This function delete a visit from Firebase Database
  ///
  /// - Parameters:
  ///   - visit: Show Visit object
  ///   - completion: Returns an error in case of deleting error
  func deleteVisit (_ visit: Show, completion: @escaping(_ error: Error?) -> Void) {
   
      visitRef.observe(.value) { (snapshot, error) in
        if error != nil {
          completion(error as? Error)
        }
        // gather all values
        for item in snapshot.children {
          
          let show = Show(snapshot: (item as? DataSnapshot)!)
          // filter values
          if show.key == visit.key {
            // delete
            self.visitRef.child(visit.key).removeValue()
          }
        }
        completion(nil)
      }
    }
  
  /// Create an entry username in database to verify if a user already exists
  ///
  /// - Parameters:
  ///   - username: String user's email
  ///   - user: user id
  func createUsername(username: String, user: String, completion: @escaping(_ error: Error?) -> Void) {
    // Set new parameters
    let newUser = [user: username] as [String: Any]
    // update DB
    usernameRef.setValue(newUser) { (error, _) in
        if error != nil {
          completion(error)
    }
      
    }
  }
  
  /// Create a Visit Entity in the Firebase database
  func createUser(username: String, lastName: String, firstName: String, date: String, password: String, authorization: Int, completion: @escaping(_ status: String, _ error: Error?) -> Void) {
    
    // create entry to log existing username
    createUsername(username: username, user: lastName) { (error)
      in
      completion("failure", error)
    }
    // Create an Auth for user
    Auth.auth().createUser(withEmail: username, password: password) { (_, error) in
      if error != nil {
        
        completion("failure", error)
      }

    }
    // Set new parameters
    let newUser = ["username": username, "lastName": lastName, "firstName": firstName, "date": date, "password": password, "authorization": authorization, "email": username] as [String: Any]
    
    // update DB
    userRef.childByAutoId().setValue(newUser) {(error, _) in
      if error != nil {
        completion("failure", error)
      } else {
        completion("success", nil)
      }
    }
  }
  
  /// Load visit entities from Firebase
  func loadUsers( completionHandler:@escaping (_ users: [User]?, _ error: Error?) -> Void) {
    userRef.observe(.value) { (snapshot, error) in
      if error != nil {
        completionHandler(nil, error as? Error)
      }
      
      var userArray: [User] = []
      // load data from firebase
      for item in snapshot.children {
        let newUser = User(snapshot: (item as? DataSnapshot)!)
        userArray.insert(newUser, at: 0)
      }
      
      // return users
      if userArray.isEmpty {
        completionHandler(nil, nil)
      } else {
        completionHandler(userArray, nil)
      }
    }
  }
  
  /// Updating User method
  func updateUser(username: String, key: String?, lastName: String, firstName: String, date: String, password: String, authorization: Int, completion: @escaping(_ status: String, _ error: Error?) -> Void) {
    // Set new parameters
    let parameters = ["username": username, "lastName": lastName, "firstName": firstName, "date": date, "password": password, "authorization": authorization] as [String: Any]
    
    // update DB
    userRef.child(key!).updateChildValues(parameters) {(error, _) in
      if error != nil {
        completion("failure", error)
      } else {
        completion("success", nil)
      }
    }
  }
  
  /// This function delete a user from Firebase Database
  func deleteUser (_ user: User) {
    guard let ref = user.ref else { return}
    ref.removeValue()
  }
  
  func uploadImagePic(data: Data, completionhandler: @escaping (_ imageUrl: String, _ error: Error?) -> Void) {
    var imageUrl = ""
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    let uuid = UUID().uuidString
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.child(uuid).putData(data, metadata: metadata) {(_, error) in
      if error != nil {
        completionhandler("", error)
      }
      self.storageRef.child(uuid).downloadURL(completion: { (url, error) in
        if error == nil {
          if let downloadUrl = url {
            // Make you download string
            imageUrl = downloadUrl.absoluteString
            
          }
        } else {
          completionhandler("", error)
        }
      completionhandler(imageUrl, nil)})
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
