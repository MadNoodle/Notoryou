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
import UIKit

struct Show {
  var title: String!
  var url: String!
  var imageName: String!
  var user: String!
  var visibility: Int!
  var ref: DatabaseReference!
  var key: String!
  var image: UIImage!
  
  // Init Show from values
  init(title: String, user:String, url: String, imageName: String, visibility: Int){
    self.ref = Database.database().reference()
    self.title = title
    self.url = "https://my.matterport.com/show/?m=\(url)&nozoom=1%27"
    self.imageName = imageName
    self.user = user
    self.visibility = visibility
    self.key = ""
    self.image = UIImage()
  }
  
  // Init Show from Firebase Snapshot values
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String: Any] else { return}
    self.ref = snapshot.ref
    self.user = dict["user"] as? String
    self.title = dict["title"] as? String
    if let visitUrl = dict["id"] as? String{
    self.url = "https://my.matterport.com/show/?m=\(visitUrl)&nozoom=1%27"
      
    }
    self.imageName = dict["imageUrl"] as? String
    self.visibility = dict["visibility"] as? Int
    self.key = snapshot.key
    self.image = UIImage()
  }

}
