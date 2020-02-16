//
//  StackView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StackView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "movedAt", ascending: true)],
        predicate: NSPredicate(format: "(completedAt == nil) AND (location = 'Stack')")
    ) var toDos: FetchedResults<ToDo>
    
    var emptyState: some View {
        VStack(spacing: 10) {
            Text("Empty")
                .font(.system(size: 34))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.white)
        }
    }
    
    var body: some View {
        Group {
            if toDos.isEmpty {
                emptyState
            }
            else {
                ZStack {
                    ForEach(
                        toDos.indices.reversed(),
                        id: \.self
                    ) { index in
                        CardView(toDo: self.toDos[index])
                    }

//                    CardView(opacity: 0.25, toDo: toDos[1])
//                        .scaleEffect(0.8)
//                        .offset(x: 0, y: -90)
//
//                    CardView(opacity: 0.5, toDo: toDos.first!)
//                        .scaleEffect(0.9)
//                        .offset(x: 0, y: -45)
//
//                    CardView(toDo: toDos[2])
                }
            }
        }
    }
}

struct StackView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
    let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let obj1 = ToDo(context: mc)
    obj1.title = "uno"
    obj1.createdAt = Date()
    obj1.movedAt = obj1.createdAt
    obj1.location = "Stack"
    
    let obj2 = ToDo(context: mc)
    obj2.title = "dos"
    obj2.createdAt = Date()
    obj2.movedAt = obj2.createdAt
    obj2.location = "Stack"

    
    let obj3 = ToDo(context: mc)
    obj3.title = "tres"
    obj3.createdAt = Date()
    obj3.movedAt = obj3.createdAt
    obj3.location = "Stack"

    
    mc.insert(obj1)
    mc.insert(obj2)
    mc.insert(obj3)
    
    return mc
    }()
    
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StackView()
                .environment(\.managedObjectContext, context)
                .padding(10)
        }
    }
}
