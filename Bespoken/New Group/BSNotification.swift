//
//  BSNotification.swift
//  Bespoken
//
//  Created by Mohan on 04/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
class BSNotification {
    var message : String?
    var updatedDate : String?
    init(_ message : String , _ updatedDate : String) {
        self.message = message
        self.updatedDate = updatedDate
    }
    init(with json : JSON) {
        self.message = json["message"] as? String
        self.updatedDate = json["updatedDate"] as? String
    }
}
