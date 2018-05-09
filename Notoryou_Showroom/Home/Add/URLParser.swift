//
//  URLParser.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 09/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

class URLParser {
  static let shared = URLParser()
  private init() {}
  
//  func parseURL(url: String)  {
//    
//    Alamofire.request(requestUrl).responseString { response in
//      
//      if let responseHtml = response.result.value {
//        print(responseHtml)
//        
//        let image = UIImage(data: responseHtml)
//        }
//      }
//    }
//   
//  }
  /*
 <div id="loading-background" style="background-image: url(";https://my.matterport.com/api/v1/player/models/pZotovsLc4z/thumb";);"></div>
 **/
  func parseHTML(html: String) -> Void {
    do {
      let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
      print(doc.css("div[id^='loading-gui']"))
      // Search for nodes by CSS selector
      for show in doc.css("div[id^='loading-background']") {
        
        // Strip the string of surrounding whitespace.
        let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       
        
          print("\(showString)\n")
      }} catch let error {
        print(error.localizedDescription)
      }
        
      }

}
