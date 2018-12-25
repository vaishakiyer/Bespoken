//
//  Attributes.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 21/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
import UIKit

typealias Attributes = [Attribute]

struct Attribute {
    
    var id, text, units: String?
    var archived: Bool?
    var updatedDate: String?
    var range: [Float]?
    var choices = [Choice]()
    var attrType: String?
    var image: String?
    var valueChosen : String?
    
    init(json: NSDictionary) {
        
        self.id  = json.value(forKey: "_id") as? String
        self.attrType = json.value(forKey: "attr_type") as? String
        
        if let options = json.value(forKey: "choices") as? [NSDictionary]{
            for item in options{
                let choice = Choice(json: item)
                self.choices.append(choice)
            }
        }
        
        self.range = json.value(forKey: "range") as? [Float]
        self.text = json.value(forKey: "text") as? String
        self.units = json.value(forKey: "units") as? String
        
        if let myImage = json.value(forKey: "images") as? String{
            image = myImage
        }else{
            if let myImage =  json.value(forKey: "image") as? String{
                image = myImage
            }
        }
        
        
    }
    
    
}

struct Choice {
    
    var text: String?
    var video: String?
    var image: String?
    var id: String?
    var measurementOptions: [String]?
    var isValSelected : Bool = false
    var isValSelected2 : Bool = false
    init(json: NSDictionary) {
        
        text = json.value(forKey: "text") as? String
        image = json.value(forKey: "image") as? String
        
        if let measOptions = json.value(forKey: "measurement_options") as? [String]{
            measurementOptions = measOptions
        }
        
        video = json.value(forKey: "video") as? String
        id = json.value(forKey: "_id") as? String
    }
    
}
