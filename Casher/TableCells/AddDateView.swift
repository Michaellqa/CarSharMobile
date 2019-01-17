//
//  AddDateView.swift
//  Casher
//
//  Created by Micky on 15/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class AddDateView: UIView {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var startDateTF: UITextField!
  @IBOutlet weak var endDateTF: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  
  var saveAction: ((String, String) -> ())?
  
  @IBAction func saveButtonClicked() {
    saveAction?("", "")
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("AddDateView", owner: self, options: nil)
    addSubview(containerView)
    containerView.frame = self.bounds
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    containerView.layer.cornerRadius = 20
    
    saveButton.backgroundColor = .white
  }
}
