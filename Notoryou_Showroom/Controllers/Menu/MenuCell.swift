//
//  MenuCell.swift
//  Notoryou_Showroom
//
//  Created by Mathieu Janneau on 17/05/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Cell to display a Menu item.
/// Each menu item must have a title and an icon
class MenuCell: UITableViewCell {

  // MARK: - OUTLETS
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    titleLabel.textColor = selected ? UIColor.yellow : UIColor.white
  }
  
}
