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
    let dateFormat = "yyyy-MM-dd"
    
    @State var todoName: String = ""
    @State var todoUntilDate: Date = Date()
    @State var todoRegisteredDate: Date = Date()
    @ObservedObject var todos = Todos()
    
    
    func resetForm() {
        todoName = ""
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
                // load phase
                todos.value = fetch()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
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
    
    @ViewBuilder func initBody() -> some View {
        Text("TodoList YEAH")
            .font(.largeTitle)
            .foregroundColor(titleColor)
        Spacer()
        VStack {
            List {
                ForEach(todos.value, id: \.id) { (todo: Todo) in
                    let name = todo.name ?? "None"
                    let untilDate = todo.untilDate != nil ? inputFormatter.string(from: todo.untilDate!) : "None"
                    let registeredDate = todo.registeredDate != nil ? inputFormatter.string(from: todo.registeredDate!) : "None"
                    Text("name: \(name)")
                    Text("until Date: \(untilDate)")
                    Text("registered Date: \(registeredDate)")
                    Divider()
                }
            }
            Form {
                Text("Add Todo")
                    .font(.title2)
                Section {
                    TextField("Name", text: $todoName)
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
            .padding()
            .onAppear() {
                UITableView.appearance().backgroundColor = .white
            }
            Spacer()
        }
    }
    
    
    var body: some View {
        return initBody()
    }
    
    init() {
        print("container viewContext: \(container.viewContext)")
        viewContext = container.viewContext
        viewContext!.automaticallyMergesChangesFromParent = true
        todos.value = fetch()
        inputFormatter.dateFormat = dateFormat
        initContainer()
    }
    
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
