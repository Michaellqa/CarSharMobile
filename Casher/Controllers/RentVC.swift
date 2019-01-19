//
//  RentVC.swift
//  Casher
//
//  Created by Micky on 16/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

enum TotalPriceResponse {
  case success(value: Double)
  case error
}

enum RentResponse {
  case success
  case priceChanged(newValue: Double)
  case error
}

protocol RentProvider {
  func total(carId: Int, date: CarDate, completion: @escaping ((TotalPriceResponse) -> ()))
  func rent(carId: Int, date: CarDate, price: Double, completion: @escaping ((RentResponse) -> ()))
}

class RentVC: UIViewController {
  @IBOutlet weak var modelLabel : UILabel!
  @IBOutlet weak var startDateLabel : UILabel!
  @IBOutlet weak var endDateLabel : UILabel!
  @IBOutlet weak var pricePerUnit: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var confirmButton: UIButton!
  
//  private let id: Int
  private let car: CarShort
  private let carDate: CarDate
  private var total: Double = 0.0
  
  var provider: RentProvider = CarsProvider(userId: KeychainWrapper.standard.integer(forKey: "Access token")!)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    modelLabel.text = car.model
    startDateLabel.text = convertTime(dateStr: carDate.start, srcFormat: DateFormatter.rfcMinutes, dstFormat: DateFormatter.display)
    endDateLabel.text = convertTime(dateStr: carDate.end, srcFormat: DateFormatter.rfcMinutes, dstFormat: DateFormatter.display)
    
    confirmButton.layer.cornerRadius = 10
    loadPrice()
  }
  
  init(car: CarShort, carDate: CarDate) {
    self.car = car
    self.carDate = carDate
    super.init(nibName: "RentVC", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("not initialized")
  }
  
  func loadPrice() {
    confirmButton.isEnabled = false
    provider.total(carId: car.id, date: carDate) { resp in
      switch resp {
      case .success(value: let total):
        self.totalPriceLabel.text = "\(total)$"
        self.total = total
        self.confirmButton.isEnabled = true
      case .error:
        self.totalPriceLabel.text = "???"
      }
    }
  }
  
  @IBAction func rent() {
    print("rent")
    let formatedDate = CarDate(
      start: convertTime(dateStr: carDate.start, srcFormat: DateFormatter.rfcMinutes, dstFormat: DateFormatter.toRfcSeconds)!,
      end: convertTime(dateStr: carDate.end, srcFormat: DateFormatter.rfcMinutes, dstFormat: DateFormatter.toRfcSeconds)!
    )
    
    provider.rent(carId: car.id, date: formatedDate, price: total) { error in
      switch error {
      case .success:
        self.goBack()
      case .priceChanged(newValue: let price):
        self.totalPriceLabel.text = "\(price)"
      case .error:
        self.showError("Не удалось забронировать")
      }
    }
  }
  
  @IBAction func showStatistics() {
    let vc = AnalyticsVC()
    present(vc, animated: true, completion: nil)
  }
}
