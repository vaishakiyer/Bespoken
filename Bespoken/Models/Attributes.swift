//
//  Attributes.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 21/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation

typealias Attributes = [Attribute]

struct Attribute: Codable {
    let id, text, units: String?
    let v: Int?
    var archived: Bool?
    let updatedDate: String?
    let range: [Int]?
    let choices: [Choice]?
    let attrType: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text, units
        case v = "__v"
        case archived, updatedDate, range, choices
        case attrType = "attr_type"
    }
}

struct Choice: Codable {
    let text: String?
    let image: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case text, image
        case id = "_id"
    }
}
