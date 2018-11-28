//
//  BSUserDefault.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit


private let kAccessToken = "kAccessToken"


class BSUserDefaults{
    
     static let sharedInstance = Foundation.UserDefaults.standard
    
    
    class func getAccessToken() -> String? {
        return sharedInstance.value(forKey: kAccessToken) as? String
    }
    
    class func setAccessToken(_ token: String?) {
        sharedInstance.setValue(token, forKey: kAccessToken)
        sharedInstance.synchronize()
    }
    
    
}
