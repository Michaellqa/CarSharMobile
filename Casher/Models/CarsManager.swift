//
//  CarsManager.swift
//  Casher
//
//  Created by Micky on 08/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import Foundation
import Alamofire

struct CarShort: Decodable {
  let image: String?
  let title: String
  let year: Int
  
  private enum CodingKeys: String, CodingKey {
    case image
    case title = "Model"
    case year = "Year"
  }
}

struct Car {
  let model: String
  let year: Int
  let mileage: Int
  let vin: String
}

enum AddCarError {
  case success, badRequest, carNotUnique
}

class CarsProvider {
  
  private struct URLs {
    static let base = "http://localhost:8080"
    static let getCars = base + "/cars"
    static let addCar = base + "/cars"
    static let ownedCars = base + "/cars"
  }
  
  func carList(userId: Int, completion: (([CarShort]) -> ())?) {
    let headers = ["Authorization": "\(userId)"]
    
    Alamofire.request(URLs.getCars, method: .get, parameters: nil, headers: headers)
      .responseData { response in
        print(response.request)
        
        switch response.result {
        case .success(let jsonData):
          print(jsonData)
          if let cars = try? JSONDecoder().decode([CarShort].self, from: jsonData) {
            completion?(cars)
          } else { print("FUCKUP parsing")}
        case .failure(let err):
          print("\(err)")
        }
    }
  }
  
  func addCar(userId: Int, car: Car, completion: @escaping ((AddCarError) -> ())) {
    let headers = ["Authorization": String(userId)]
    let params: [String : Any] = [
      "Model": car.model,
      "Year": car.year,
      "Mileage": car.mileage,
      "Vin": car.vin
      ]
    
    Alamofire.request(URLs.addCar, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        switch response.response?.statusCode {
        case 200:
          completion(.success)
        case 409:
          completion(.carNotUnique)
        default:
          print(response.error)
          completion(.badRequest)
        }
    }
  }
  
  func ownedCars(userId: Int, completion: (([OwnedCar]) -> ())?) {
    
    let dummy: [OwnedCar] = [
      OwnedCar(image: nil , model: "Tesla", status: RentStatus(rawValue: 1)!),
      OwnedCar(image: nil , model: "Range Rover", status: RentStatus(rawValue: 2)!)
    ]
    completion?(dummy)
    return
    
    let headers = ["Authorization": String(userId)]
    let params: [String: Any] = [:]
    
    Alamofire.request(URLs.ownedCars, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseData { response in
        
        switch response.result {
        case .success(let jsonData):
          print(jsonData)
          if let cars = try? JSONDecoder().decode([OwnedCar].self, from: jsonData) {
            completion?(cars)
          } else { print("FUCKUP parsing")}
        case .failure(let err):
          print("\(err)")
          completion?([])
        }
    }
  }
}

extension CarsProvider: CarPublisher, RentCarsDataSource, AccountManager {
  
}
