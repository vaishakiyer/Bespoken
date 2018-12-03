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
    let id, title, subtitle: String?
    let v: Int?
    let archived: Bool?
    let updatedDate: String?
    let showInitial: Bool?
    let tab: Int?
    var options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, subtitle
        case v = "__v"
        case archived, updatedDate
        case showInitial = "show_initial"
        case tab, options
    }
}

struct Option: Codable {
    let text: String?
    let image: String?
    let id: String?
    var archived: Bool?
    
    enum CodingKeys: String, CodingKey {
        case text, image
        case id = "_id"
        case archived
    }
}


struct PostAnswers {

    var question : String?
    var answers = [String]()
    
    init(question: String) {
        self.question = question
    }
    
}
