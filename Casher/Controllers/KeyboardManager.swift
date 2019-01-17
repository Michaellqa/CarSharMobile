//
//  KeyboardManager.swift
//  Casher
//
//  Created by Micky on 15/12/2018.
//  Copyright © 2018 Micky. All rights reserved.
//

import UIKit

protocol KeyboardManager {
  func begin()
  func end()
}

extension KeyboardManager where Self: UIViewController {
  func begin() {
    view.subviews.forEach {
      if $0 is UITextField {
        
      }
    }
  }
}
