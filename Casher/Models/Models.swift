//
//  OwnedCar.swift
//  Casher
//
//  Created by Micky on 13/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import UIKit

enum RentStatus: Int, Decodable {
  case inactive = 0
  case waiting = 1
  case rentSoon = 2
  case rentedNow = 3
}

struct OwnedCar: Decodable {
  let id: Int
  let image: String?
  let model: String
  let status: RentStatus
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case image = "image"
    case model = "model"
    case status = "status"
  }
}


struct CarShort: Decodable {
  let id: Int
  let image: String?
  let model: String
  let year: Int
  
  private enum CodingKeys: String, CodingKey {
    case id, image, model, year
  }
}


struct Car: Codable {
  let model: String
  let year: Int
  let mileage: Int
  let vin: String
  
  private enum CodingKeys: String, CodingKey {
    case model, vin, mileage, year
  }
}


enum TimeUnit: String, Codable {
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


struct CarPrice: Codable {
  let timeUnit: TimeUnit
  let price: Double
  
  private enum CodingKeys: String, CodingKey {
    case timeUnit, price
  }
}


struct CarDate: Codable {
  let start: String
  let end: String
  
  private enum CodingKeys: String, CodingKey {
    case start = "startTime"
    case end = "endTime"
  }
}


struct Total: Codable {
  
  struct Part: Codable {
    let unit: String
    let base: Double
    let count: Int
  }
  
  let value: Double
  let parts: [Part]?
}
