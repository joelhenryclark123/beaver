//
//  StoreItem.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct StoreItem: View {
    var toDo: ToDo
    
    var body: some View {
        HStack {
            Button(action: {
                self.toDo.location = "Stack"
                do {
                    try self.toDo.managedObjectContext?.save()
                } catch {
                    fatalError()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("stackBackgroundColor"))
            }
            Text(toDo.title)

            Spacer()
            }.frame(maxWidth: .infinity).padding()
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
            .previewLayout(.sizeThatFits)
    }
}
