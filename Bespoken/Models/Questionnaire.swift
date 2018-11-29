//
//  Questionnaire.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 28/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import Foundation

typealias Questionnaire = [QuestionnaireElement]

struct QuestionnaireElement: Codable {
    let id, text: String?
    let v: Int?
    let archived: Bool?
    let updatedDate: String?
    var options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case v = "__v"
        case archived, updatedDate, options
    }
}

struct Option: Codable {
    let text, id: String?
    var archived: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case text
        case id = "_id"
        case archived
    }
}

