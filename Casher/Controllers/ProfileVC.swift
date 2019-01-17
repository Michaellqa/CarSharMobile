//
//  ProfileVC.swift
//  Casher
//
//  Created by Micky on 07/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol AccountManager {
  func ownedCars(completion: (([OwnedCar]) -> ())?)
}

class ProfileVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var logOutButton: UIButton!
  
  private var ownedCars: [OwnedCar] = []
  var accountManager: AccountManager = CarsProvider(userId: KeychainWrapper.standard.integer(forKey: "Access token")!)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "UserCarsCell", bundle: nil), forCellReuseIdentifier: "UserCarsCell")
    
    logOutButton.layer.borderWidth = 1
    logOutButton.layer.borderColor = UIColor.red.cgColor
    
    loadInfo()
  }
  
  @IBAction func logOutButtonPressed(_ sender: UIButton) {
    logOut()
  }
  
  func goToCar() {
    let vc = CarPropertiesVC()
    self.present(vc, animated: true, completion: nil)
  }
  
  private func logOut() {
    print("logout")
    KeychainWrapper.standard.removeObject(forKey: "Access token")
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  private func loadInfo() {
    let userId = KeychainWrapper.standard.integer(forKey: "Access token")!
    accountManager.ownedCars() { cars in
      self.ownedCars = cars
      self.tableView.reloadData()
    }
  }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UserCarsCell.height
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ownedCars.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCarsCell", for: indexPath) as! UserCarsCell
    cell.backgroundColor = .clear
    cell.prepareUI()
    
    let car = ownedCars[indexPath.row]
    cell.titleLabel.text = car.model
    cell.setStatus(car.status)

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    goToCar()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
