//
//  Todos.swift
//  TodoList
//
//  Created by jiho lee on 2021/03/08.
//

import Foundation


class Todos: ObservableObject {
    @Published var value: [Todo] = []
}
