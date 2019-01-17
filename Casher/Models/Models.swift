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
  let image: String?
  let title: String
  let year: Int
  
  private enum CodingKeys: String, CodingKey {
    case image
    case title = "model"
    case year = "year"
  }
}


struct Car: Codable {
  let model: String
  let year: Int
  let mileage: Int
  let vin: String
  
  private enum CodingKeys: String, CodingKey {
    case model, vin
    case mileage
    case year
  }
}
