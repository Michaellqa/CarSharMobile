//
//  TableHeader.swift
//  Casher
//
//  Created by Micky on 16/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class TableHeader: UIView {
  let label: UILabel = {
    let l = UILabel()
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    backgroundColor = UIColor(white: 0.95, alpha: 1)
    addSubview(label)
    label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
  }
}
