//
//  TodoView.swift
//  TodoList
//
//  Created by jiho lee on 2021/03/07.
//

import SwiftUI

struct TodoView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Todo.entity(), sortDescriptors: []) var todos: FetchedResults<Todo>
    let titleColor: Color = Color(#colorLiteral(red: 0.4731488228, green: 0.7680833936, blue: 0.8298937678, alpha: 1))
    let inputFormatter = DateFormatter()
    let dateFormat = "yyyy-MM-dd"
    var body: some View {
        Text("TodoList YEAH")
            .font(.headline)
            .foregroundColor(titleColor)
        Spacer()
        VStack {
            List {
                ForEach(todos, id: \.id) { (todo: Todo) in
                    let name = todo.name != nil ? todo.name! : "None"
                    let untilDate = todo.untilDate != nil ? inputFormatter.string(from: todo.untilDate!) : "None"
                    let registeredDate = todo.registeredDate != nil ? inputFormatter.string(from: todo.registeredDate!) : "None"
                    Text("name: \(name)")
                    Text("until Date: \(untilDate)")
                    Text("registered Date: \(registeredDate)")
                }
            }
        }
        Spacer()
    }
    
    init() {
        inputFormatter.dateFormat = dateFormat
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
