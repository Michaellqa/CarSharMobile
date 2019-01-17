//
//  AddPriceView.swift
//  Casher
//
//  Created by Micky on 15/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class AddPriceView: UIView {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var priceField: UITextField!
  @IBOutlet weak var timeLabel: UILabel!

  @IBOutlet weak var hourButton: UIButton!
  @IBOutlet weak var dayButton: UIButton!
  @IBOutlet weak var weekButton: UIButton!
  
  @IBOutlet weak var saveButton: UIButton!
  
  var saveAction: ((CarPrice) -> ())?
  private var timeUnit: TimeUnit = .hour
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    Bundle.main.loadNibNamed("AddPriceView", owner: self, options: nil)
    addSubview(containerView)
    containerView.frame = self.bounds
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    containerView.layer.cornerRadius = 20
    
    for v in [hourButton, dayButton, weekButton, saveButton] {
      v?.layer.borderColor = UIColor.white.cgColor
      v?.layer.borderWidth = 1
      v?.layer.cornerRadius = 10
    }
    saveButton.backgroundColor = .white
  }
  
  @IBAction func pickTimeUnit(_ sender: UIButton) {
    switch sender {
    case hourButton:
      timeUnit = .hour
    case dayButton:
      timeUnit = .day
    case weekButton:
      timeUnit = .week
    default:
      return
    }
    timeLabel.text = "per \(timeUnit.string())"
  }
  
  @IBAction func save() {
    saveAction?(CarPrice(timeUnit: timeUnit, price: 0))
    return
    
    guard let text = priceField.text, let price = Double(text) else {
      return
    }
    saveAction?(CarPrice(timeUnit: timeUnit, price: price))
  }
}
