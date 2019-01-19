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

enum ResponseError {
  case none, someError
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
  private let headers: [String: String]
  
  init(userId: Int) {
    self.userId = userId
    self.headers = ["Authorization": "\(userId)"]
  }
  
  func carList(date: CarDate?, completion: (([CarShort]) -> ())?) {
    var params: [String:Any] = [:]
    if let date = date {
      params["start"] = date.start
      params["end"] = date.end
    }
    
    Alamofire.request(URLs.getCars, method: .get, parameters: params, headers: headers)
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
  
  func saveDate(carId: Int, date: CarDate, completion: @escaping ((ResponseError) -> ())) {
    let params: [String: Any] = [
      "startTime": date.start,
      "endTime": date.end
    ]
    let url = "\(URLs.getCars)/\(carId)/dates"
    
    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        print("\(url): ", response.response?.statusCode)
        
        switch response.response?.statusCode {
        case 200:
          completion(.none)
        default:
          completion(.someError)
        }
    }
  }
  
  func savePrice(carId: Int, price: CarPrice, completion: @escaping ((ResponseError) -> ())) {
    let params: [String: Any] = [
      "timeUnit": price.timeUnit.rawValue,
      "price": price.price
    ]
    let url = "\(URLs.getCars)/\(carId)/prices"
    
    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        print("\(url): ", response.response?.statusCode)
        
        switch response.response?.statusCode {
        case 200:
          completion(.none)
        default:
          completion(.someError)
        }
    }
  }
  
  
  
  func dates(carId: Int, completion: @escaping (([CarDate]) -> ())) {
    let url = "\(URLs.getCars)/\(carId)/dates"
    
    Alamofire.request(url, method: .get, parameters: [:], headers: headers)
      .responseData { response in
        print("\(url): ", response.response?.statusCode)
        switch response.result {
        case .success(let jsonData):
          print(jsonData)
          if let dates = try? JSONDecoder().decode([CarDate].self, from: jsonData) {
            completion(dates)
          } else {
            print("FUCKUP parsing")
          }
        case .failure(let err):
          print("\(err)")
          completion([])
        }
    }
  }
  
  func prices(carId: Int, completion: @escaping (([CarPrice]) -> ())) {
    let url = "\(URLs.getCars)/\(carId)/prices"
    
    Alamofire.request(url, method: .get, parameters: [:], headers: headers)
      .responseData { response in
        print("\(url): ", response.response?.statusCode)
        switch response.result {
        case .success(let jsonData):
          print(jsonData)
          if let prices = try? JSONDecoder().decode([CarPrice].self, from: jsonData) {
            completion(prices)
          } else {
            print("FUCKUP parsing")
          }
        case .failure(let err):
          print("\(err)")
          completion([])
        }
    }
  }
  
  func total(carId: Int, date: CarDate, completion: @escaping ((TotalPriceResponse) -> ())) {
    let url = "\(URLs.base)/cars/\(carId)/\(date.start)/\(date.end)/total"
    
    Alamofire.request(url, method: .get, parameters: nil, headers: headers)
      .responseData { response in
        print("\(url): ", response.response?.statusCode)
        
        switch response.result {
        case .success(let jsonData):
          print(String.init(data: jsonData, encoding: .utf8))
          if let total = try? JSONDecoder().decode(Total.self, from: jsonData) {
            completion(.success(value: total.value))
          } else {
            print("total FUCKUP")
          }
        default:
          completion(.error)
        }
    }
  }
  
  func rent(carId: Int, date: CarDate, price: Double, completion: @escaping ((RentResponse) -> ())) {
    let params: [String: Any] = [
      "startTime": date.start,
      "endTime": date.end,
      "total": price,
    ]
    let url = "\(URLs.base)/cars/\(carId)/rent"
    
    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .response { response in
        print("\(url): ", response.response?.statusCode)
        
        switch response.response?.statusCode {
        case 200:
          completion(.success)
        case 409:
          if let data = response.data,
            let text = String(bytes: data, encoding: .utf8),
            let total = Double(text) {
            completion(.priceChanged(newValue: total))
            return
          }
          print("haven't received new price")
        default:
          completion(.error)
        }
    }
  }
}

extension CarsProvider: CarPublisher, RentCarsDataSource, AccountManager, DatesPricesProvider, RentProvider {

}
