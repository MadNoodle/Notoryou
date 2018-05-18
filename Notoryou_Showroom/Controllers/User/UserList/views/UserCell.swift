//
//  UserCell.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 16/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var access: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
