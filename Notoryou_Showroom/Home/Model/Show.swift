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

struct Show {
  var title: String!
  var url: String!
  var imageName: String!
  var user: String!
  var ref: DatabaseReference!
  var key: String!
  
  // Init Show from values
  init(title: String, user:String, url: String, imageName:String){
    self.ref = Database.database().reference()
    self.title = title
    self.url = "https://my.matterport.com/show/?m=\(url)&nozoom=1%27"
    self.imageName = imageName
    self.user = user
    self.key = ""
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
    self.key = snapshot.key
  }
//  /// Return an array of shows
//  ///
//  /// - Returns: [Shows]
//  static func loadShows() -> [Show] {
//    return [
//      Show(title: "Atelier Meraki - Exposition Ding Dong", user:"M", url: "axQCCxDjUSn", imageName: "https://cdn-1.matterport.com/apifs/models/axQCCxDjUSn/images/Qu9JdtZqWpH/11.28.2017_13.11.53.jpg?t=2-cad37ffbd0c0f65fd08ec4e46c2e887259c7188a-1526479624-1"),
//    Show(title: "Galerie Sakura - Exposition 'L Art dans la Peau'", url: "zwcXgFCdic4", imageName: "https://cdn-1.matterport.com/apifs/models/zwcXgFCdic4/images/E9wabtyhxut/12.06.2017_19.12.35.jpg?t=2-73f5cbad8759368e05715501616d61c603fca50f-1526479684-1"),
//    Show(title: "Galerie Schwab Beaubourg - Exposition Marc Petit", url: "k1iLzUjnGpQ", imageName: "https://cdn-1.matterport.com/apifs/models/k1iLzUjnGpQ/images/EaB36Dh9v37/12.03.2017_12.22.20.jpg?t=2-ace543617acc7577ed2043295bfba113d32d8fa3-1526479700-1"),
//    Show(title: "Elysée Montmartre", url: "fUW4Etm5J1m", imageName: "https://cdn-1.matterport.com/apifs/models/fUW4Etm5J1m/images/7JWj8qEYWxX/04.23.2018_16.19.56.jpg?t=2-a8c8acd95bd1d3e71b156bed80c217da05ae46f9-1526479721-1"),
//    Show(title: "Palais Vivienne", url: "gkNzfWuRMum", imageName: "https://cdn-1.matterport.com/apifs/models/gkNzfWuRMum/images/vMJW4DphMop/01.30.2018_13.08.19.jpg?t=2-80df267c3f4b0ff53deb225592ec3415e8675869-1526480289-1"),
//    Show(title: "Jockey Disque", url: "MPgHmZRsHL9", imageName: "https://cdn-1.matterport.com/apifs/models/MPgHmZRsHL9/images/osXrVfTgM1U/03.22.2018_01.48.33.jpg?t=2-ea65dd8b6911a94d2842ecbbe40d71a7a307aac7-1526480264-1"),
//    Show(title: "Trianon", url: "KQp3Uwv2EJu", imageName: "https://cdn-1.matterport.com/apifs/models/KQp3Uwv2EJu/images/WFnY8QsvE2B/04.23.2018_16.17.05.jpg?t=2-80f3579bec0a38fb089ff09e6ffaeb7ebec3d541-1526479560-1"),
//    Show(title: "Studio Atlas", url: "ypwDT5NyKtG", imageName: "https://cdn-1.matterport.com/apifs/models/ypwDT5NyKtG/images/dsiQtqr8ULX/03.11.2018_15.21.49.jpg?t=2-223665a3b9734bdc2aa7252f818a2011939fd898-1526480217-1"),
//    Show(title: "Label Valette Festival 2018", url: "ctWMDK9mdKm", imageName: "https://cdn-1.matterport.com/apifs/models/ctWMDK9mdKm/images/NC1myXzL717/03.30.2018_18.52.02.jpg?t=2-d2d726f7d9f76407ab92f3b4f1ee3ae6be7ff02e-1526480193-1"),
//    Show(title: "Hôtel Salomon de Rothschild", url: "A3vkHFv2RNn", imageName: "https://cdn-1.matterport.com/apifs/models/A3vkHFv2RNn/images/ibMRmkcK3tc/02.22.2018_15.22.58.jpg?t=2-275d52a7d966f0e291c00c54c90f859868758514-1526480167-1"),
//    Show(title: "Galerie du Passage / Pierre Passebon - Exposition \"Movimiento\" par Giuseppe Ducrot", url: "9mU6M7gPAM5", imageName: "https://cdn-1.matterport.com/apifs/models/9mU6M7gPAM5/images/MXfJ5dQq9AE/04.15.2018_18.11.00.jpg?t=2-d5369e5372a29954a5a608016534ee1c9ddfb9ce-1526477479-1"),
//    Show(title: "Galerie Vrais Rêves", url: "LZnavjqdt1j", imageName: "https://cdn-1.matterport.com/apifs/models/LZnavjqdt1j/images/E4NGPCnYtSH/04.23.2018_15.41.38.jpg?t=2-0a99577d1afcc0a7eec83ead7374440d45851dc0-1526480116-1"),
//    Show(title: "Sotheby’s Paris DESIGN 3 MAY 2018", url: "pZotovsLc4z", imageName: "https://cdn-1.matterport.com/apifs/models/pZotovsLc4z/images/uXgTUsWdWqY/04.27.2018_11.16.53.jpg?t=2-25d49fa6e95f30e0a902446242abbd14e86fb17c-1526479480-1"),
//    Show(title: "Bastille Design Center -Expo Figuration Critique 2017\"", url: "PonE5H5DmJH", imageName: "https://cdn-1.matterport.com/apifs/models/PonE5H5DmJH/images/BNvpRNmsmG9/10.26.2017_16.53.30.jpg?t=2-4e2efca8200a587697ce4c847e7e6bf2ebb89197-1526480312-1"),
//    Show(title: "Galerie Goutal", url: "gWQiQGo3x6s", imageName: "https://cdn-1.matterport.com/apifs/models/gWQiQGo3x6s/images/H4hf33PRcS6/01.15.2018_13.04.40.jpg?t=2-154f736a04a5ec00d32af8f67a770a79da468614-1526480347-1"),
//    Show(title: "Galerie Jeanne Bucher Jaeger", url: "6afLgC7mGLq", imageName: "https://cdn-1.matterport.com/apifs/models/6afLgC7mGLq/images/rvafqYU39Gt/03.27.2018_17.09.04.jpg?t=2-37aa46ceb5bef3e180860eed7986d7a45091ab33-1526477611-1"),
//    Show(title: "Galerie Minsky - Exposition Geneviève Hugon", url: "Lt9aui6VRnY", imageName: "https://cdn-1.matterport.com/apifs/models/Lt9aui6VRnY/images/gKR8MGKBavT/12.30.2017_14.14.47.jpg?t=2-7b827106aabcb298806f06f01de946160fe4eaa7-1526480389-1"),
//    Show(title: "Galerie Perpitch & Bringand - Exposition Alexandre Mussard \"Carte blanche #5\"", url: "hAT6KCoCSsP", imageName: "https://cdn-1.matterport.com/apifs/models/hAT6KCoCSsP/images/UaHwyx6hoUL/12.20.2017_18.51.09.jpg?t=2-a441268125a5b5ed8af2dee2b0fc0b4eaa8acbd2-1526480413-1"),
//    Show(title: "Hélène Bailly Gallery - Février 2018", url: "vPKpNQuXHa2", imageName: "https://cdn-1.matterport.com/apifs/models/vPKpNQuXHa2/images/fPVtAeZBvBB/01.08.2018_17.24.51.jpg?t=2-ccca05e109d0be24269676ddfb3a33efbcbd46b9-1526480454-1"),
//    Show(title: "MEP - Exposition \"Obsession Marlène\" - 08.11.2017 / 25.02.2018", url: "9LEp6h6CrSi", imageName: "https://cdn-1.matterport.com/apifs/models/9LEp6h6CrSi/images/BRVuHTwHmZU/01.17.2018_12.01.03.jpg?t=2-4c6c99f2e52096985eb4ea92f374ca1d5330670b-1526480476-1"),
//    Show(title: "Pierre Yves Caer Gallery - Exposition Chisato Tanaka", url: "p1cgNutAZXZ", imageName: "https://cdn-1.matterport.com/apifs/models/p1cgNutAZXZ/images/nzsv6WU1Avn/12.06.2017_14.06.14.jpg?t=2-4988cce33234ac0bb978ab61eccaf0f820cc9a4e-1526480498-1"),
//    Show(title: "The Anonymous Project #1", url: "tFJK9PxGchF", imageName: "https://cdn-1.matterport.com/apifs/models/tFJK9PxGchF/images/dPwP191hcK6/02.05.2018_13.22.15.jpg?t=2-be0a2f9aec85cf1e53c1eeba79d241f5c9820b97-1526480550-1")
//    ]
//  }
}
