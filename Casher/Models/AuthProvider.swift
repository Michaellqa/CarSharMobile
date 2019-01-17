//
//  AuthManager.swift
//  Casher
//
//  Created by Micky on 12/12/2018.
//  Copyright © 2018 Micky. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthProvider {
  func logIn(phone: String, pass: String, completion: @escaping (AuthResult) -> ())
  func signUp(user: NewUser, completion: @escaping (SignupError) -> ())
}

struct NewUser {
  let phone: String
  let pass: String
  let name: String
  let birthDate: String
}

enum AuthResult {
  case success(uid: Int)
  case failed
}

enum SignupError {
  case none, userExists
}


class AuthManager: AuthProvider {
  
  private struct Urls {
    static let base = "http://localhost:8080"
    static let userCreate = base + "/users"
    static let userAuth = base + "/user"
  }
  
  func logIn(phone: String, pass: String, completion: @escaping (AuthResult) -> ()) {
    let params = ["Phone": phone, "Password": pass]
    
    Alamofire.request(Urls.userAuth, method: .get, parameters: params)
      .responseString { resp in
        print(resp.request ?? "no request")
        
        if resp.response?.statusCode == 400 {
          print("SHOULD NEVER HAPPEN")
          completion(.failed)
          return
        }
        if resp.response?.statusCode == 404 {
          print("BAD LOGIN")
          completion(.failed)
          return
        }
        if resp.response?.statusCode == 403 {
          print("BAD PASSWORD")
          completion(.failed)
          return
        }

        if let data = resp.data,
          let text = String(bytes: data, encoding: .utf8),
          let userId = Int(text) {
          completion(.success(uid: userId))
          return
        }
        print("FUCKUP in LOGIN")
    }
  }
  
  
  func signUp(user: NewUser, completion: @escaping (SignupError) -> ()) {
    guard let date = ISODateFormat(date: user.birthDate) else {
      return
    }
    
    let params = [
      "Phone": user.phone,
      "Password": user.pass,
      "Name": user.name,
      "BirthDate": date
    ]
    Alamofire.request(Urls.userCreate, method: .post, parameters: params, encoding: JSONEncoding.default)
      .validate()
      .response { resp in
        if resp.response?.statusCode == 409 {
          completion(.userExists)
        }
        completion(.none)
    }
  }
  
  private func ISODateFormat(date: String) -> String? {
    let formatterFrom = DateFormatter()
    formatterFrom.dateFormat = "dd/MM/yyyy"
    
    guard let date = formatterFrom.date(from: date) else {
      return nil
    }
    
    let formatterTo = ISO8601DateFormatter()
    return formatterTo.string(from: date)
  }
}

