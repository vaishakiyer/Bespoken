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
 
 static let baseURLString = "Http://Creating a network Layer"
 
 case configureURL(urlString: String)
 case getBPMProcess()
 
 var method: Alamofire.HTTPMethod {
 switch self {
 case .configureURL:
 return .post
 default:
 return .get
 }
 }
 
 var path: String{
 
 switch self {
 case .configureURL(let urlString):
 return "configuration?organisationUrl=\(urlString)"
 default:
 return "api/v1/bpmTasks"
 }
 }
 
 
 
 func asURLRequest() throws -> URLRequest{
 
 let urlString = Router.baseURLString + path
 var urlRequest = URLRequest(url: URL(string: urlString)!)
 urlRequest.httpMethod = method.rawValue
 
 urlRequest.setValue("Incture Technologies", forHTTPHeaderField: "organization")
 
 switch self {
 case .configureURL(let email):
 
 let parameters = ["email": email]
 return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
 default:
 return try Alamofire.JSONEncoding.default.encode(urlRequest, with: nil)
 }
 
 }
 
 }
 
 
 struct DemoStruct: Codable {
 var name,address : String?
 }
 
 class ExecuteNetworkClass{
 
 func getRequest(){
 
 Alamofire.request(Router.configureURL(urlString: "user")).responseJSON { (response) in
 switch response.result{
 
 case .success(let JSON):
 print(JSON)
 
 let x = try? JSONDecoder().decode(DemoStruct.self, from: response.data!)
 print(x!)
 
 case.failure(_):
 break
 }
 }
 
 }
 
 }
 



