//
//  CarPropertiesVC.swift
//  Casher
//
//  Created by Micky on 15/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

protocol DatesPricesProvider {
  func saveDate(carId: Int, date: CarDate, completion: @escaping ((ResponseError) -> ()))
  func savePrice(carId: Int, price: CarPrice, completion: @escaping ((ResponseError) -> ()))
  
  func dates(carId: Int, completion: @escaping (([CarDate]) -> ()))
  func prices(carId: Int, completion: @escaping (([CarPrice]) -> ()))
}

class CarPropertiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let datePicker = UIDatePicker()
  @IBOutlet weak var tableView: UITableView!
  private var prices: [CarPrice] = []
  private var dates: [CarDate] = []
  
  var dataProvider: DatesPricesProvider!
  var car: OwnedCar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "TitleValueCell", bundle: nil), forCellReuseIdentifier: "TitleValueCell")
    tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    tableView.dataSource = self
    tableView.delegate = self
    
    bindDatePicker()
    loadDatesAndPrices()
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
      self?.savePrice()
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
      self?.saveDate()
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
  
  func saveDate() {
    guard let s = addDateView.startDateTF.text, !s.isEmpty,
      let e = addDateView.endDateTF.text, !e.isEmpty else {
        showError("fill in fields")
        return
    }
    
    let inFormatter = DateFormatter()
    inFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    
    guard let start = inFormatter.date(from: s),
      let end = inFormatter.date(from: e) else {
        showError("incorrect")
        return
    }
    
    let outFormatter = DateFormatter()
    outFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let startStr = outFormatter.string(from: start)
    let endStr = outFormatter.string(from: end)
    
    let date = CarDate(start: startStr, end: endStr)
    
    dataProvider.saveDate(carId: car.id, date: date) { error in
      if error == .none {
        self.hidePicker(self.addDateView)
        self.loadDatesAndPrices()
      } else {
        print("haven't saved")
      }
    }
  }
  
  func savePrice() {
    guard let p = addPriceView.priceField.text, let price = Double(p) else {
      showError("incorrect")
      return
    }
    
    let carPrice = CarPrice(timeUnit: addPriceView.timeUnit, price: price)
    dataProvider.savePrice(carId: car.id, price: carPrice) { err in
      if err == .none {
        self.hidePicker(self.addPriceView)
        self.loadDatesAndPrices()
      }
    }
  }
  
  func loadDatesAndPrices() {
    dataProvider.prices(carId: car.id) { prices in
      print("prices:", prices.count)
      self.prices = prices
      self.tableView.reloadData()
    }
    dataProvider.dates(carId: car.id) { dates in
      print("dates:", dates.count)
      self.dates = dates
      self.tableView.reloadData()
    }
  }
  
  private func showPicker(_ picker: UIView) {
    view.addSubview(picker)
    picker.alpha = 0
    UIView.animate(withDuration: 0.2) {
      picker.alpha = 1
    }
  }
  
  private func hidePicker(_ picker: UIView) {
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
      if dates.count == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.button.addTarget(nil, action: #selector(addDate), for: .touchUpInside)
        cell.button.setTitle("Add Date", for: .normal)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleValueCell", for: indexPath) as! TitleValueCell
        let date = dates[indexPath.row]
        cell.titleLabel.text = convertTime(dateStr: date.start, srcFormat: "yyyy-MM-dd'T'HH:mm:ssZ", dstFormat: "dd/MM/yyyy hh:mm")
        cell.valueLabel.text = convertTime(dateStr: date.end, srcFormat: "yyyy-MM-dd'T'HH:mm:ssZ", dstFormat: "dd/MM/yyyy hh:mm")
        return cell
      }
      
    case 2:
      if prices.count == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.button.addTarget(nil, action: #selector(addPrice), for: .touchUpInside)
        cell.button.setTitle("Add Price", for: .normal)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleValueCell", for: indexPath) as! TitleValueCell
        let price = prices[indexPath.row]
        cell.titleLabel.text = price.timeUnit.string()
        cell.valueLabel.text = "\(price.price)$"
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
    case 1: return dates.count + 1
    case 2: return prices.count + 1
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
    addDateView.endDateTF.inputView = datePicker
    addDateView.endDateTF.inputAccessoryView = toolbar
  }
  
  @objc func donePicker(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy hh:mm"
    if addDateView.startDateTF.isFirstResponder {
      addDateView.startDateTF.text = formatter.string(from: datePicker.date)
    }
    if addDateView.endDateTF.isFirstResponder {
      addDateView.endDateTF.text = formatter.string(from: datePicker.date)
    }
    
    self.view.endEditing(true)
  }
  
  @objc func cancelPicker(){
    self.view.endEditing(true)
  }
}

