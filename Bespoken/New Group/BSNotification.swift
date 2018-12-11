//
//  BSNotification.swift
//  Bespoken
//
//  Created by Mohan on 04/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation
class BSNotification {
    var title : String?
    var text : String?
    var image : String?
    init(_ title : String , _ text : String, _ image : String?) {
        self.title = title
        self.text = text
        self.image = image!
    }
}
