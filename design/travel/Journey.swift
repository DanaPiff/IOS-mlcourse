//
//  Journey.swift
//  design
//
//  Created by Dana on 19.11.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation

//структуры соответствуют json-у, который приходит в ответ от гугла

struct Journey: Decodable {
    var routes: [Routes]
}

struct Routes: Decodable {
    var legs: [Legs]
}

struct Legs: Decodable {
    var distance: Distance
    var duration: Duration
}

struct Distance: Decodable {
    var text: String
    //значение в секундах
    var value: Int
}

struct Duration: Decodable {
    var text: String
    //значение в метрах
    var value: Int
}
