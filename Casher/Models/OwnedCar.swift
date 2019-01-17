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
  let image: String?
  let model: String
  let status: RentStatus
  
  private enum CodingKeys: String, CodingKey {
    case image = "Image"
    case model = "Model"
    case status = "Status"
  }
}
