//
//  extensions.swift
//  Casher
//
//  Created by Micky on 18/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import Foundation

extension DateFormatter {
  static let rfcMinutes = "yyyy-MM-dd'T'HH:mmZ"
  static let rfcSeconds = "yyyy-MM-dd'T'HH:mm:ssZ"
  static let toRfcSeconds = "yyyy-MM-dd'T'HH:mm:ss'Z'"
  static let display = "dd/MM/yyyy HH:mm"
}

func convertTime(dateStr: String, srcFormat: String, dstFormat: String) -> String? {
  let formatter = DateFormatter()
  formatter.dateFormat = srcFormat
  guard let date = formatter.date(from: dateStr) else {
    print("cannot format \(dateStr) as \(srcFormat)")
    return nil
  }
  print("formatted \(dateStr) as \(srcFormat)")
  formatter.dateFormat = dstFormat
  return formatter.string(from: date)
}
