//
//  TodoClass.swift
//  TodoList
//
//  Created by jiho lee on 2021/03/08.
//

import Foundation

struct Todo {
    var name: String
    var registeredTime: Date
    var untilTime: Date?
    
    init(name: String, registeredTime: Date, untilTime: Date?) {
        self.name = name
        self.registeredTime = registeredTime
        self.untilTime = untilTime
    }
    
}
