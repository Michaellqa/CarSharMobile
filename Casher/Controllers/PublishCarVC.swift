//
//  PublishCarVC.swift
//  Casher
//
//  Created by Micky on 08/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol CarPublisher {
  func addCar(userId: Int, car: Car, completion: @escaping ((AddCarError) -> ()))
}

class PublishCarVC: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var modelTF: UITextField!
  @IBOutlet weak var yearTF: UITextField!
  @IBOutlet weak var mileageTF: UITextField!
  @IBOutlet weak var vinTF: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  
  var publisher: CarPublisher = CarsProvider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    saveButton.layer.borderColor = UIColor.green.cgColor
    saveButton.layer.borderWidth = 1
    saveButton.layer.cornerRadius = 5
    saveButton.backgroundColor = UIColor(red: 0.3, green: 1, blue: 0.3, alpha: 0.1)
    
    imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    imageView.layer.cornerRadius = imageView.frame.height / 2
    
    modelTF.delegate = self
    yearTF.delegate = self
    mileageTF.delegate = self
  }
  
  @IBAction func publishButtonPressed() {
    publish()
  }
  
  func publish() {
    let fields = [modelTF, yearTF, mileageTF, vinTF]
    if (fields.compactMap { $0?.text }.contains { $0 == "" }) {
      showError("Please fill in all fields")
      return
    }
    guard
      let year = Int(yearTF.text!),
      let mileage = Int(mileageTF.text!) else {
      print(yearTF.text!)
      return
    }
    
    let car = Car(model: modelTF.text!, year: year, mileage: mileage, vin: vinTF.text!)
    let userId = KeychainWrapper.standard.integer(forKey: "Access token")!
    
    publisher.addCar(userId: userId, car: car) { err in
      switch err {
      case .success:
        self.showSuccess()
      case .carNotUnique:
        self.showError("VIN already been registered")
      case .badRequest:
        self.showError("Unknown error")
      }
    }
  }
  
  func showSuccess() {
    let alert = UIAlertController(title: "Success", message: "Car was added", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      self.tabBarController?.selectedIndex = 1
    }
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
}

extension PublishCarVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
