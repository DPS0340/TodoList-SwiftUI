//
//  TodoView.swift
//  TodoList
//
//  Created by jiho lee on 2021/03/07.
//

import SwiftUI
import CoreData

struct TodoView: View {
    @State var container: NSPersistentContainer = NSPersistentContainer(name: "Model")
    
    var viewContext: NSManagedObjectContext? = nil
    let titleColor: Color = Color(#colorLiteral(red: 0.4731488228, green: 0.7680833936, blue: 0.8298937678, alpha: 1))
    let inputFormatter = DateFormatter()
    let dateFormat = "yyyy-MM-dd hh:mm"
    
    @State var todoName: String = ""
    @State var todoUntilDate: Date = Date()
    @State var todoRegisteredDate: Date = Date()
    @State var todoContent: String = ""
    @ObservedObject var todos = Todos()
    @State var showingSheet = false

    
    
    func resetForm() {
        todoName = ""
        todoContent = ""
        todoUntilDate = Date()
    }
    
    func initContainer() {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    
    // save & load pattern
    func saveContext() {
        if viewContext == nil {
            print("saveContext: viewContent is nil")
            return
        }
        if viewContext!.hasChanges {
            do {
                // save phase
                try viewContext!.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
        // load phase
        todos.value = fetch()
    }
    
    func submit() {
        if viewContext == nil {
            print("submit: viewContent is nil")
            return
        }
        todoRegisteredDate = Date()
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: viewContext!)!
        let obj = NSManagedObject(entity: entity, insertInto: viewContext)
        guard let todo = obj as? Todo else { return }
        todo.name = todoName
        todo.content = todoContent
        todo.untilDate = todoUntilDate
        todo.registeredDate = todoRegisteredDate
        saveContext()
        resetForm()
    }
    
    func fetch() -> [Todo] {
        if viewContext == nil {
            return []
        }
        let todoResults = NSFetchRequest<Todo>(entityName: "Todo")
        let todos: [Todo] = try! viewContext!.fetch(todoResults) as [Todo]
        return todos
    }
    
    func deleteOne(object: Todo) {
        viewContext!.delete(object)
        todos.value = todos.value.filter { $0 != object }
    }
    
    func deleteAll() {
        for todo in todos.value {
            viewContext!.delete(todo)
        }
        todos.value = []
    }
    
    
    var body: some View {
        Text("TodoList YEAH")
            .font(.largeTitle)
            .foregroundColor(titleColor)
        Spacer()
        VStack {
            List {
                ForEach(todos.value, id: \.id) { (todo: Todo) in
                    let name = todo.name ?? "None"
                    let content = todo.content ?? "None"
                    let untilDate = todo.untilDate != nil ? inputFormatter.string(from: todo.untilDate!) : "None"
                    let registeredDate = todo.registeredDate != nil ? inputFormatter.string(from: todo.registeredDate!) : "None"
                    Button(action: {
                        showingSheet = true
                    }) {
                        Text("name: \(name)")
                    }
                    .actionSheet(isPresented: $showingSheet) {
                        ActionSheet(title: Text("\(name)"), message: Text("\(content) \(registeredDate) - \(untilDate)"), buttons: [.default(Text("Dismiss")), .cancel(Text("Cancel"))])
                    }
                    Button(action: {
                        deleteOne(object: todo)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
                Button(action: {
                    deleteAll()
                }) {
                    Text("YEAH")
                        .foregroundColor(titleColor)
                }
                Text("Add Todo")
                    .font(.title2)
                TextField("Name", text: $todoName)
                TextField("Content", text: $todoContent)
                DatePicker(selection: $todoRegisteredDate, in: Date()...) {
                    Text("Until Date")
                }
                Button(action: {
                    submit()
                }) {
                    Text("Submit")
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    init() {
        initContainer()
        print("container viewContext: \(container.viewContext)")
        viewContext = container.viewContext
        viewContext!.automaticallyMergesChangesFromParent = true
        inputFormatter.dateFormat = dateFormat
        todos.value = fetch()
    }
    
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
