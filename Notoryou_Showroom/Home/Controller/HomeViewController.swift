//
//  HomeViewController.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var shows = [Show]()
  var currentShow: Show?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Visites"
    shows = Show.loadShows()
    // Register cell classes
    let nib = UINib(nibName: "Showcell", bundle: nil)
   tableView.register(nib, forCellReuseIdentifier: "myCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShow))
    self.navigationItem.rightBarButtonItem = addButton
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  @objc func addShow() {
    let addVc = AddViewController()
    self.navigationController?.pushViewController(addVc, animated: true)
  }
  
  
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shows.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? Showcell
    cell?.showTitle.text = shows[indexPath.row].title
    if let thumb = URL(string: shows[indexPath.row].imageName){ cell?.thumbnail.sd_setImage(with: thumb , placeholderImage: #imageLiteral(resourceName: "logo_nty"), options: [.continueInBackground, .progressiveDownload])}
    print(shows[indexPath.row].imageName)
    
    //cell?.thumbnail.image = UIImage(named: shows[indexPath.row].imageName)
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentShow = shows[indexPath.row] 
    let playerVc = PlayerViewController()
    playerVc.url = currentShow.url
    self.navigationController?.pushViewController(playerVc, animated: true)
  }
  
  func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      completion(data, response, error)
      }.resume()
  }
}
