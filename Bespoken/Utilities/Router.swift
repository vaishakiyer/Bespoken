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
    case getEvents(lat: String,long: String)
    case getNotifications()
    case getWishlistItems()
    case getAllProducts()
    case getThemeboardCards()
    case getAffinityCards()
    case postSwipedCards(direction: String, cardId: String,isProduct: Bool)
    case getTheCards()
    case getTheCardsForEvent(eventID: String)
    case getStyleWords()
    case getProductBy(id: String)
    case getEventBy(id: String)
    case getAttributesByProduct(id: String)
    case ProductSearch(searchText : String)
    case postAttributes(prodId: String,preferences: [NSDictionary])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .inviteUser,.getQuestions,.signIn,.confirmUser,.getUser,.updateUser,.getEvents ,.getNotifications , .getWishlistItems,.getThemeboardCards,.getAffinityCards,.postSwipedCards,.getTheCards,.getTheCardsForEvent,.getStyleWords,.getProductBy,.getEventBy,.getAttributesByProduct , .ProductSearch , .postAttributes:
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
        case .getNotifications:
            return "getNotifications"
        case .getWishlistItems:
            return "getWishlistItems"
        case .getAllProducts():
            return "getProducts"
        case .getThemeboardCards:
            return "getThemeboardcards"
        case .getAffinityCards:
            return "getAffinitycards"
        case .postSwipedCards:
            return "recordSwipe"
        case .getTheCards:
            return "getProducts"
        case .getTheCardsForEvent:
             return "getProducts"
        case .getStyleWords:
            return "getStyleWords"
        case .getProductBy:
            return "getProduct"
        case .getEventBy:
            return "getEvent"
        case .getAttributesByProduct:
            return "getAttributesbyProduct"
        case .ProductSearch:
            return "ProductSearch"
        case .postAttributes:
            return "createBooking"
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
        case .postSwipedCards(let direction, let cardId,let isProduct):
            
            var parameters = [String: Any]()
            if isProduct == true{
                 parameters = ["direction": direction,"product": cardId]
            }else{
                 parameters = ["direction": direction,"themeboard": cardId]
            }
            
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .getEvents(let lat,let long):
            
            let parameters = ["lat": lat,"long": long]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getTheCardsForEvent(let eventID):
            let parameters = ["event_id": eventID]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getEventBy(let id):
            
            let parameters = ["_id": id]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getProductBy(let id):
            
            let parameters = ["_id": id]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .getAttributesByProduct(let id):
            
            let parameters = ["product": id]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .ProductSearch(let searchText):
            let parameters = ["tag" : searchText]
        
        case .postAttributes(let id, let answers):
            
            let parameters = [ "product" : id, "preferences" : answers] as [String : Any]
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
    }
    
}








