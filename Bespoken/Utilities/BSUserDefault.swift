//
//  BSUserDefault.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit


private let kAccessToken = "kAccessToken"
private let kUser = "kUser"
private let kProfilePic = "kProfilePic"
private let kLoggedName = "kName"
private let kWords = "kWords"
private let kFirstTime = "kFirstTime"



class BSUserDefaults{
    
     static let sharedInstance = Foundation.UserDefaults.standard
    
    
    class func getAccessToken() -> String? {
        return sharedInstance.value(forKey: kAccessToken) as? String
    }
    
    class func setAccessToken(_ token: String?) {
        sharedInstance.setValue(token, forKey: kAccessToken)
        sharedInstance.synchronize()
    }
    
    class func setLoggedName(_ name: String){
        sharedInstance.set(name, forKey: kLoggedName)
        sharedInstance.synchronize()
    }
    
    class func loggedName() -> String?{
       return sharedInstance.value(forKey: kLoggedName) as? String
    }
    
    class func loggedInUser() -> User? {
        let data = Foundation.UserDefaults.standard.object(forKey: kUser) as! Data
        let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! NSDictionary
        return User(jsonObject: object!)
    }
    
    class func setLoggedInUserDict(_ userDict: NSDictionary) {
        sharedInstance.set(try? NSKeyedArchiver.archivedData(withRootObject: userDict, requiringSecureCoding: true), forKey: kUser)
        sharedInstance.synchronize()
    }
    class func setProfilePic(_ profileImage: UIImage) {
        sharedInstance.set(try? NSKeyedArchiver.archivedData(withRootObject: profileImage, requiringSecureCoding: true), forKey: kProfilePic)
        sharedInstance.synchronize()
    }
    class func getProfilePic() -> UIImage {
        if let data = Foundation.UserDefaults.standard.object(forKey: kProfilePic) as? Data{
        let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! UIImage
        return object!
        }
        return UIImage(named: "profile")!
    }

    
    class func setLoggedWords(_ words: [String]){
        sharedInstance.set(words, forKey: kWords)
        sharedInstance.synchronize()
    }
    
    class func getLoggedWords() -> [String]?{
        return sharedInstance.value(forKey: kWords) as? [String]
    }
    
    class func setFirstTime(val: Bool){
        
        sharedInstance.set(val, forKey: kFirstTime)
        sharedInstance.synchronize()
    }
    
    class func getFirstTime() -> Bool?{
        
         return sharedInstance.value(forKey: kFirstTime) as? Bool
    }
    class func removeAll(){
        if let appDomain = Bundle.main.bundleIdentifier {
            sharedInstance.removePersistentDomain(forName: appDomain)
        }
    }
}
