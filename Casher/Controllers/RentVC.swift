//
//  RentVC.swift
//  Casher
//
//  Created by Micky on 16/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

class RentVC: UIViewController {
  @IBOutlet weak var pricePerUnit: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var confirmButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.2)
  }
  
  init(carId: Int, startDate: String, endDate: String) {
    super.init(nibName: "RentVC", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func loadPrice() {
    let price = 1234
    totalPriceLabel.text = "Total: \(price)$"
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
}
