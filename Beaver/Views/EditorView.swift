//
//  EditorView.swift
//  Beaver
//
//  Created by Joel Clark on 1/29/21.
//  Copyright © 2021 MyCo. All rights reserved.
//

import SwiftUI

struct EditorView: View {
    @State var title: String = ""
    @ObservedObject var toDo: ToDo
    @Binding var showing: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                Spacer()
            }
            .padding()
            .navigationTitle("Edit")
            .navigationBarItems(leading: Button("Save") {
                toDo.title = title
                toDo.saveContext()
                showing = false
            })
        }
        .onAppear(perform: {
            title = toDo.title
        })
    }
}
