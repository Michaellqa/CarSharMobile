//
//  RentCarListCell.swift
//  Casher
//
//  Created by Micky on 07/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class RentCarListCell: UITableViewCell {
  static let height: CGFloat = 110
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var cardView: UIView!
  
  func prepareUI() {
    contentView.backgroundColor = .clear
    cardView.layer.cornerRadius = 25
    cardView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    iconView.layer.cornerRadius = 10
  }
}
