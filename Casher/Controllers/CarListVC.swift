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
  func carList(userId: Int, completion: (([CarShort]) -> ())?)
}

class CarListVC: UIViewController {
  
  @IBOutlet weak var startDateTF: UITextField!
  @IBOutlet weak var endDateTF: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func searchButtonClicked(_ sender: UIButton) {
    search(startDate: startDateTF.text!, endDate: endDateTF.text!)
  }
  
  func search(startDate: String, endDate: String) {
    print("searching cars available between \(startDate) and \(endDate)")
  }
  
  private var cars: [CarShort] = []
  var carsProvider: RentCarsDataSource = CarsProvider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorColor = .clear
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UINib(nibName: "RentCarListCell", bundle: nil), forCellReuseIdentifier: "RentCell")
    
    loadCars()
  }
  
  func loadCars() {
    let userId = KeychainWrapper.standard.integer(forKey: "Access token")!
    carsProvider.carList(userId: userId) { [weak self] res in
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
//    let carId = cars[indexPath.row].id
    let carId = 2
    goToRent(carId: carId)
  }
  
  func goToRent(carId: Int) {
    let vc = RentVC(carId: carId, startDate: "", endDate: "")
    present(vc, animated: true, completion: nil)
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
    cell.titleLabel.text = car.title
    cell.yearLabel.text = "Year: \(car.year)"
    
    return cell
  }
}
