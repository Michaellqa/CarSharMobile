//
//  CarListVC.swift
//  Casher
//
//  Created by Micky on 15/12/2018.
//  Copyright © 2018 Micky. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol RentCarsDataSource {
  func carList(date: CarDate?, completion: (([CarShort]) -> ())?)
}

class CarListVC: UIViewController {
  
  private let datePicker = UIDatePicker()
  @IBOutlet weak var startDateTF: UITextField!
  @IBOutlet weak var endDateTF: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func searchButtonClicked(_ sender: UIButton) {
    loadCars()
  }
  
  private var cars: [CarShort] = []
  var carsProvider: RentCarsDataSource = CarsProvider(userId: KeychainWrapper.standard.integer(forKey: "Access token")!)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorColor = .clear
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UINib(nibName: "RentCarListCell", bundle: nil), forCellReuseIdentifier: "RentCell")
    
    loadCars()
    bindDatePicker()
  }
  
  func loadCars() {
    var date: CarDate? = nil
    if let startStr = startDateTF.text, !startStr.isEmpty,
      let endStr = endDateTF.text, !endStr.isEmpty,
      let start = convertTime(dateStr: startStr, srcFormat: "dd/MM/yyyy HH:mm", dstFormat: "yyyy-MM-dd'T'HH:mm'Z'"),
      let end = convertTime(dateStr: endStr, srcFormat: "dd/MM/yyyy HH:mm", dstFormat: "yyyy-MM-dd'T'HH:mm'Z'")
    {
      date = CarDate(start: start, end: end)
    }
    
    carsProvider.carList(date: date) { [weak self] res in
      self?.cars = res
      self?.tableView.reloadData()
    }
  }
}

extension CarListVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return RentCarListCell.height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let car = cars[indexPath.row]
    goToRent(car: car)
  }
  
  func goToRent(car: CarShort) {
    if let startStr = startDateTF.text, !startStr.isEmpty,
      let endStr = endDateTF.text, !endStr.isEmpty,
      let start = convertTime(dateStr: startStr, srcFormat: "dd/MM/yyyy HH:mm", dstFormat: "yyyy-MM-dd'T'HH:mm'Z'"),
      let end = convertTime(dateStr: endStr, srcFormat: "dd/MM/yyyy HH:mm", dstFormat: "yyyy-MM-dd'T'HH:mm'Z'")
    {
      let date = CarDate(start: start, end: end)
      let vc = RentVC(car: car, carDate: date)
      present(vc, animated: true, completion: nil)
    } else {
      print("not gonna")
    }
  }
}

extension CarListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cars.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RentCell", for: indexPath) as! RentCarListCell
    cell.prepareUI()
    let car = cars[indexPath.row]
    cell.titleLabel.text = car.model
    cell.yearLabel.text = "Year: \(car.year)"
    return cell
  }
}


extension CarListVC {
  func bindDatePicker() {
    datePicker.datePickerMode = .dateAndTime
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker))
    
    toolbar.setItems([cancelButton, space, doneButton], animated: true)
    
    startDateTF.inputView = datePicker
    startDateTF.inputAccessoryView = toolbar
    endDateTF.inputView = datePicker
    endDateTF.inputAccessoryView = toolbar
  }
  
  @objc func donePicker(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy hh:mm"
    if startDateTF.isFirstResponder {
      startDateTF.text = formatter.string(from: datePicker.date)
    }
    if endDateTF.isFirstResponder {
      endDateTF.text = formatter.string(from: datePicker.date)
    }
    
    self.view.endEditing(true)
  }
  
  @objc func cancelPicker(){
    self.view.endEditing(true)
  }
}
