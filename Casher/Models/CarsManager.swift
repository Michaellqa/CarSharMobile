//
//  CarsManager.swift
//  Casher
//
//  Created by Micky on 08/01/2019.
//  Copyright © 2019 Micky. All rights reserved.
//

import Foundation
import Alamofire

enum AddCarError {
  case success, badRequest, carNotUnique
}

class CarsProvider {
  
  private struct URLs {
    static let base = "http://localhost:8080"
    static let getCars = base + "/cars"
    static let addCar = base + "/cars"
    static let ownedCars = base + "/users"
    
    static let findCar = base + "/cars"
    static let addDate =  base + "/cars"
    static let addPrice = base + "/cars"
  }
  
  private let userId: Int
  
  init(userId: Int) {
    self.userId = userId
  }
  
  func carList(completion: (([CarShort]) -> ())?) {
    let headers = ["Authorization": "\(userId)"]
    
    Alamofire.request(URLs.getCars, method: .get, parameters: nil, headers: headers)
      .responseData { response in
        print("carList", response.request)
        
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
  
  func addCar(car: Car, completion: @escaping ((AddCarError) -> ())) {
    let headers = ["Authorization": String(userId)]
    let params: [String : Any] = [
      "Model": car.model,
      "Year": car.year,
      "Mileage": car.mileage,
      "Vin": car.vin
      ]
    
    Alamofire.request(URLs.addCar, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        
        print("addCar ", response.request)
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
  
  func ownedCars(completion: (([OwnedCar]) -> ())?) {
    
//    let dummy: [OwnedCar] = [
//      OwnedCar(image: nil , model: "Tesla", status: RentStatus(rawValue: 1)!),
//      OwnedCar(image: nil , model: "Range Rover", status: RentStatus(rawValue: 2)!)
//    ]
//    completion?(dummy)
//    return
    
    let headers = ["Authorization": String(userId)]
    let params: [String: Any] = [:]
    let url = "\(URLs.ownedCars)/\(userId)/cars"
    
    Alamofire.request(url, method: .get, parameters: params, headers: headers)
      .responseData { response in
        print("\(url): ", response.response?.statusCode)
        switch response.result {
        case .success(let jsonData):
          print(String(bytes: jsonData, encoding: .utf8))
          if let cars = try? JSONDecoder().decode([OwnedCar].self, from: jsonData) {
            completion?(cars)
          } else {
            print("FUCKUP parsing")
            completion?([])
          }
        case .failure(let err):
          print("\(err)")
          completion?([])
        }
    }
  }
  
  func findCar(car: Car, completion: @escaping ((Car) -> ())) {
    let headers = ["Authorization": String(userId)]
    let params: [String : Any] = [
      :
    ]
    
    Alamofire.request(URLs.addCar, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseData { response in
        
        switch response.result {
        case .success(let jsonData):
          print(jsonData)
          if let car = try? JSONDecoder().decode(Car.self, from: jsonData) {
            completion(car)
          } else {
            print("FUCKUP parsing")
          }
        case .failure(let err):
          print("\(err)")
//          completion(nil)
        }
    }
  }
}

extension CarsProvider: CarPublisher, RentCarsDataSource, AccountManager {
  
}
