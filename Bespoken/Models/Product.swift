//
//  Product.swift
//  Bespoken
//
//  Created by Mohan on 15/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//
typealias JSON = [String : Any]

import Foundation
import UIKit

class Product {
    var id : String
    var title : String
    var description : String
    var price : CGFloat
    var cost : CGFloat
    var currency : String
    var city : String
    var season : String
    var archived : Bool
    var images : [String]
    var attributes : [String]
    var styletip : StyleTip?
    var tags : [String]
    
    init(json: JSON) {
            self.id = json["_id"] as! String
            self.title = json["title"] as! String
            self.price = json["price"] as! CGFloat
            self.cost = json["cost"] as! CGFloat
            self.currency = json["currency"] as! String
            self.images = json["images"] as! [String]
            self.city = json["city"] as! String
            self.season = json["season"] as! String
            self.tags = json["tags"] as! [String]
            if let dict = json["styletip"] as? NSDictionary{
            self.styletip = StyleTip(json: dict)
          }
            self.archived = json["archived"] as! Bool
            self.description = json["description"] as! String
            self.attributes = json["attributes"] as! [String]
        
    }
    
    
}

struct StyleTip {
    
    var cardId : String?
    var author : String?
    var text: String?
    var video : String?
    
    init(json: NSDictionary) {
        
        cardId = json.value(forKey: "_id") as? String
        author = json.value(forKey: "author") as? String
        text = json.value(forKey: "text") as? String
        video = json.value(forKey: "video") as? String
    }
    
}
