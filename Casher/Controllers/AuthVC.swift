//
//  ViewController.swift
//  Casher
//
//  Created by Micky on 11/12/2018.
//  Copyright © 2018 Micky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

enum AuthState {
  case login, signup
}

class AuthVC: UIViewController {
  
  private let datePicker = UIDatePicker()
  
  @IBOutlet weak var phoneTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var dateTF: UITextField!
  
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var modeButton: UIButton!
  
  var authManager: AuthProvider = AuthManager()
  private var state: AuthState = .login

  override func viewDidLoad() {
    super.viewDidLoad()
    bindDatePicker()
  
    phoneTF.delegate = self
    nameTF.delegate = self
    passwordTF.delegate = self
    
  }
  
  @IBAction func changeModeClicked(_ sender: UIButton) {
    switchMode()
  }
  
  @IBAction func submitClicked(_ sender: UIButton) {
    if state == .login {
      logIn()
    } else {
      signUp()
    }
  }
  
  func logIn() {
    KeychainWrapper.standard.set(32, forKey: "Access token")
    goToMain()
    return
    
    guard let phone = phoneTF.text, !phone.isEmpty,
      let pass = passwordTF.text, !pass.isEmpty else {
        showError("Please fill in all fields")
        return
    }
    
    fadeOut()
    authManager.logIn(phone: phone, pass: pass) { res in
      defer { self.fadeIn() }
      
      switch res {
      case .failed:
        self.showError("Incorrect login or password")
      case .success(uid: let userId):
        if !KeychainWrapper.standard.set(userId, forKey: "Access token") {
          print("TOKEN WASN'T SAVED")
          return
        }
        self.goToMain()
      }
    }
  }
  
  func signUp() {
    guard let user = userData() else {
      showError("Please fill in all fields")
      return
    }
    
    fadeOut()
    authManager.signUp(user: user) { error in
      defer { self.fadeIn() }
      
      if error == .userExists {
        self.showError("This phone number is already taken")
      }
      if error != nil {
        self.showError("Smth happened")
      }
      self.logIn()
    }
  }
  
  func goToMain() {
    let tabController = UITabBarController()
    
    let profileTab = ProfileVC()
    profileTab.title = "Profile"
    
    let listTab = CarListVC() 
    listTab.title = "Cars"
    
    let publishCarTab = PublishCarVC()
    publishCarTab.title = "Add"
    
    tabController.viewControllers = [profileTab, listTab, publishCarTab]
    present(tabController, animated: true, completion: nil)
  }
  
  func userData() -> NewUser? {
    let emptyFieldsLeft = [phoneTF, passwordTF, nameTF, dateTF]
      .map { $0?.text ?? "" }
      .contains { $0 == "" }
    guard !emptyFieldsLeft else { return nil }
    return NewUser(phone: phoneTF.text!,
                   pass: passwordTF.text!,
                   name: nameTF.text!,
                   birthDate: dateTF.text!)
  }
  
  func switchMode() {
    if state == .login {
      modeButton.setTitle("Back to login", for: .normal)
      submitButton.setTitle("SignUp", for: .normal)
      state = .signup
      
      UIView.animate(withDuration: 0.3) {
        self.nameTF.alpha = 1
        self.dateTF.alpha = 1
      }
    } else {
      modeButton.setTitle("Create account", for: .normal)
      submitButton.setTitle("LogIn", for: .normal)
      state = .login
      UIView.animate(withDuration: 0.3) {
        self.nameTF.alpha = 0
        self.dateTF.alpha = 0
      }
    }
  }
}

extension AuthVC {
  func bindDatePicker() {
    datePicker.datePickerMode = .date
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker))
    
    toolbar.setItems([cancelButton, space, doneButton], animated: true)
    
    dateTF.inputView = datePicker
    dateTF.inputAccessoryView = toolbar
  }
  
  @objc func donePicker(){
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    dateTF.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  @objc func cancelPicker(){
    self.view.endEditing(true)
  }
}


extension AuthVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension AuthVC {
  func fadeOut() {
    self.view.isUserInteractionEnabled = false
    UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseInOut, animations: {
      self.view.alpha = 0.8
    })
  }
  
  func fadeIn() {
    self.view.isUserInteractionEnabled = true
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
      self.view.alpha = 1
    })
  }
}

extension UIViewController {
  func showError(_ text: String) {
    let alert = UIAlertController(title: "Incorrect values", message: text, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}

