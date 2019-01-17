//
//  test.swift
//  Casher
//
//  Created by Micky on 07/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//
import UIKit

//class ViewController: UIViewController {
//
//  @IBOutlet weak var txtDatePicker: UITextField!
//  let datePicker = UIDatePicker()
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    showDatePicker()
//  }
//
//
//  func showDatePicker(){
//    datePicker.datePickerMode = .date
//    let toolbar = UIToolbar();
//    toolbar.sizeToFit()
//
//    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
//    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
//    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//
//    txtDatePicker.inputAccessoryView = toolbar
//    txtDatePicker.inputView = datePicker
//
//  }
//
//  func donedatePicker(){
//    let formatter = DateFormatter()
//    formatter.dateFormat = "dd/MM/yyyy"
//    txtDatePicker.text = formatter.string(from: datePicker.date)
//    //dismiss date picker dialog
//    self.view.endEditing(true)
//  }
//
//  func cancelDatePicker(){
//    //cancel button dismiss datepicker dialog
//    self.view.endEditing(true)
//  }
//}
