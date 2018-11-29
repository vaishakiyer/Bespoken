//
//  User.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 29/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Foundation



class User{
    
    var userId : String?
    var admin  : Bool?
    var confirmed: Bool?
    var email : String?
    var firstName: String?
    var inviteCode : Int?
    var preferences : [String]?
    var role : String?
    var updatedDate: String?
    
    init(jsonObject: NSDictionary){
        
        userId = jsonObject.value(forKey: "_id") as? String
        admin =  jsonObject.value(forKey: "admin") as? Bool
        confirmed = jsonObject.value(forKey: "confirmed") as? Bool
        email = jsonObject.value(forKey: "email") as? String
        firstName = jsonObject.value(forKey: "firstName") as? String
        inviteCode = jsonObject.value(forKey: "invitecode") as? Int
        preferences = jsonObject.value(forKey: "preferences") as? [String]
        role = jsonObject.value(forKey: "role") as? String
        updatedDate = jsonObject.value(forKey: "updatedDate") as? String
    }
    
    
    
}
