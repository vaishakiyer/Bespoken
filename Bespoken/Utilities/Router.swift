//
//  Router.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


 
 enum Router: URLRequestConvertible{
 
 static let baseURLString = "http://13.232.8.9/api/"
 
 case inviteUser(firstN: String,phone: String,email:String)
 case confirmUser(email: String,invitecode: String,password:String)
 case signIn(email: String,password: String)
 case getQuestions()
 case getUser()
 case updateUser(answers: [NSDictionary])
 case getEvents()
    
 var method: Alamofire.HTTPMethod {
 switch self {
 case .inviteUser,.getQuestions,.signIn,.confirmUser,.getUser,.updateUser,.getEvents:
 return .post
 default:
 return .get
 }
 }
 
 var path: String{
 
 switch self {
 case .inviteUser:
 return "inviteUser"
 
 case .confirmUser:
    return "confirmUser"
 case .getQuestions:
    
    return "getQuestions"
 case .signIn:
    return "signIn"
  case .getUser:
    return "getUser"
 case .updateUser:
    return "updateUser"
 case .getEvents:
    return "getEvents"
 }
 }
 
 
 
 func asURLRequest() throws -> URLRequest{
 
 let urlString = Router.baseURLString + path
 var urlRequest = URLRequest(url: URL(string: urlString)!)
 urlRequest.httpMethod = method.rawValue
 
    if let token = BSUserDefaults.getAccessToken(){
        urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
    }

 
 switch self {
 case .inviteUser(let fName,let phone,let email):
 
    let parameters = ["email": email,"firstName": fName,"phone": phone]
 return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
    
 case .confirmUser(let email, let invitecode, let password):
    
    let parameters = ["email": email,"invitecode": invitecode,"password": password]
    return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
    
 case .signIn(let email,let password):
    let parameters = ["email": email,"password": password]
    return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
    
 case .updateUser(let answers):
    let parameters = ["preferences" : answers]
    return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
 default:
 return try Alamofire.JSONEncoding.default.encode(urlRequest, with: nil)
 }
 
 }
 
 }
 
 
 struct DemoStruct: Codable {
 var name,address : String?
 }
 
// class ExecuteNetworkClass{
//
// func getRequest(){
//
// Alamofire.request(Router.configureURL(urlString: "user")).responseJSON { (response) in
// switch response.result{
//
// case .success(let JSON):
// print(JSON)
//
// let x = try? JSONDecoder().decode(DemoStruct.self, from: response.data!)
// print(x!)
//
// case.failure(_):
// break
// }
// }
//
// }
//
// }




