//
//  ContentView.swift
//  Shared
//
//  Created by jiho lee on 2021/03/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("TodoList SwiftUI 🤔")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: TodoView())
                {
                    Text("TODOLIST")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
