//
//  StoreItem.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StoreItem: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    var toDo: ToDo
    
    var body: some View {
        HStack {
            Button(action: select) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("stackBackgroundColor"))
            }
            Text(toDo.title)

            Spacer()
            }.frame(maxWidth: .infinity).padding()
    }
    
    func select() {
        state.moveActiveToStore()
        
        // Move this to do to the stack
        self.toDo.location = "Stack"
        self.toDo.movedAt = Date()
        do {
            try self.toDo.managedObjectContext?.save()
        } catch {
            fatalError()
        }
        
        // Change Scene To Stack
        state.currentScene = .stack
    }
}

struct StoreItem_Previews: PreviewProvider {
    static var toDo: ToDo = {
        let returner = ToDo(context: ContentView_Previews.context)
        returner.title = "Grind?"
        returner.createdAt = Date()
        return returner
    }()
    
    static var previews: some View {
        StoreItem(toDo: toDo)
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
    }
}
