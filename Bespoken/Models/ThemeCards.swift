//
//  ThemeCards.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 15/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation

protocol BasicAttributes {
    
    
    var cardId: String?{get}
    var title: String? {get}
    var desc: String? {get}
    var image: String? {get}
    
}

struct ThemeCards: BasicAttributes {
    
    var cardId: String?
    
    var title: String?
    
    var desc: String?
    
    var image: String?
    
}
