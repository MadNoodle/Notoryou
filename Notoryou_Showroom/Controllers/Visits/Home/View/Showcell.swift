//
//  Showcell.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 08/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class Showcell: UITableViewCell {

  @IBOutlet weak var showTitle: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    // Set shadow for text
    showTitle.layer.shadowColor = UIColor.black.cgColor
    showTitle.layer.shadowRadius = 2.0
    showTitle.layer.shadowOpacity = 0.7
    showTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
    showTitle.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    if editing {
      self.editingAccessoryView?.backgroundColor = .black
  }
  }  
}
