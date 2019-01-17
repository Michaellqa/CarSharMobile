//
//  CarPropertiesVC.swift
//  Casher
//
//  Created by Micky on 15/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

enum TimeUnit: Int {
  case hour
  case day
  case week
  
  func string() -> String {
    switch self {
    case .hour:
      return "Hour"
    case .day:
      return "Day"
    case .week:
      return "Week"
    }
  }
}

struct CarPrice {
  let timeUnit: TimeUnit
  let price: Double
}

struct CarDate {
  let start: String
  let end: String
}

class CarPropertiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let datePicker = UIDatePicker()
  @IBOutlet weak var tableView: UITableView!
//  private let car: Car
  private var prices: [CarPrice] = []
  private var dates: [CarDate] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "TitleValueCell", bundle: nil), forCellReuseIdentifier: "TitleValueCell")
    tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    tableView.dataSource = self
    tableView.delegate = self
    
//    let nb = UINavigationBar()
//    view.addSubview(nb)
  }
  
  @objc private func goBack() {
    dismiss(animated: true, completion: nil)
  }
  
  private lazy var addPriceView: AddPriceView = {
    let v = AddPriceView(frame: CGRect(
    x: view.center.x - 130,
    y: view.center.y - 150,
    width: 260,
    height: 300))
    v.saveAction = { [weak self] day in
      guard self != nil else { return }
      self!.hidePicker(self!.addPriceView)
    }
    return v
  }()
  
  private lazy var addDateView: AddDateView = {
    let v = AddDateView(frame: CGRect(
      x: view.center.x - 130,
      y: view.center.y - 150,
      width: 260,
      height: 300))
    v.saveAction = { [weak self] s1, s2 in
      guard self != nil else { return }
      self!.hidePicker(self!.addDateView)
      self!.dismiss(animated: true, completion: nil)
    }
    return v
  }()
  
  @objc func addDate() {
    print("date")
    showPicker(addDateView)
  }
  @objc func addPrice() {
    print("price")
    showPicker(addPriceView)
  }
  
  private func showPicker(_ picker: UIView) {
    view.addSubview(picker)
    picker.alpha = 0
    UIView.animate(withDuration: 0.2) {
      picker.alpha = 1
    }
  }
  
  func hidePicker(_ picker: UIView) {
    print("buy")
    UIView.animate(withDuration: 0.2, animations: {
      picker.alpha = 0
    }) { finished in
      picker.removeFromSuperview()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      let l = TableHeader()
      l.label.text = "profile"
      return l
    case 1:
      let l = TableHeader()
      l.label.text = "dates"
      return l
    case 2:
      let l = TableHeader()
      l.label.text = "prices"
      return l
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 1:
      if prices.count == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.button.addTarget(nil, action: #selector(addDate), for: .touchUpInside)
        cell.button.setTitle("Add Date", for: .normal)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleValueCell", for: indexPath)
        return cell
      }
      
    case 2:
      if prices.count == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.button.addTarget(nil, action: #selector(addPrice), for: .touchUpInside)
        cell.button.setTitle("Add Price", for: .normal)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleValueCell", for: indexPath)
        return cell
      }
      
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "TitleValueCell", for: indexPath) as! TitleValueCell
      cell.backgroundColor = .yellow
      cell.titleLabel.text = ""
      cell.valueLabel.text = ""
      cell.heightAnchor.constraint(equalToConstant: 150).isActive = true
      return cell
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return max(prices.count, 1)
    case 2: return max(dates.count, 1)
    default: return 0
    }
  }
}

extension CarPropertiesVC {
  func bindDatePicker() {
    datePicker.datePickerMode = .dateAndTime
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker))
    
    toolbar.setItems([cancelButton, space, doneButton], animated: true)
    
    addDateView.startDateTF.inputView = datePicker
    addDateView.startDateTF.inputAccessoryView = toolbar
  }
  
  @objc func donePicker(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy hh:mm"
    addDateView.startDateTF.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  @objc func cancelPicker(){
    self.view.endEditing(true)
  }
}
