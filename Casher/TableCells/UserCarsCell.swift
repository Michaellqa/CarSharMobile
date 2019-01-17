//
//  UserCarsCell.swift
//  Casher
//
//  Created by Micky on 08/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class UserCarsCell: UITableViewCell {
  static let height: CGFloat = 90
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusIndicator: UIView!
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var cardView: UIView!
  
  func setStatus(_ status: RentStatus) {
    statusLabel.text = status.message().title
    statusIndicator.backgroundColor = status.message().color
  }
  
  func prepareUI() {
    contentView.backgroundColor = .clear
    cardView.layer.cornerRadius = 25
    cardView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    iconView.layer.cornerRadius = 10
    statusIndicator.layer.cornerRadius = statusIndicator.frame.height / 2
  }
}

struct StatusMessage {
  let title: String
  let color: UIColor
}

extension RentStatus {
  func message() -> StatusMessage {
    switch self {
    case .inactive:
      return StatusMessage(title: "Inavalible to rent", color: .gray)
    case .waiting:
      return StatusMessage(title: "Waiting for rent", color: .green)
    case .rentSoon:
        return StatusMessage(title: "Gonna be rented soon", color: .yellow)
    case .rentedNow:
      return StatusMessage(title: "Rented now", color: .red)
    }
  }
}
