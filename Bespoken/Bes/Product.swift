//
//  Product.swift
//  Bespoken
//
//  Created by Mohan on 15/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//
typealias JSON = [String : Any]

import Foundation
class Product {
    var id : String
    var title : String
    var description : String
    var price : String
    var cost : String
    var currency : String
    var city : String
    var season : String
    var archived : Bool
    var images : [String]
    var attributes : [String]
    var styletip : [String : String]
    var tags : [String]
    
    init(json: JSON) {
            self.id = json["_id"] as! String
            self.title = json["title"] as! String
            self.price = ""//json["price"] as! String
            self.cost = ""//json["cost"] as! String
            self.currency = json["currency"] as! String
            self.images = json["images"] as! [String]
            self.city = json["city"] as! String
            self.season = json["season"] as! String
            self.tags = json["tags"] as! [String]
            self.styletip = json["styletip"] as! [String: String]
            self.archived = json["archived"] as! Bool
            self.description = json["description"] as! String
            self.attributes = json["attributes"] as! [String]
        
    }
    
    
}
