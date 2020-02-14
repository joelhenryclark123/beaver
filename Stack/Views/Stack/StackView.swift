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
        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)],
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
                    CardView(opacity: 0.25, toDo: toDos.first!)
                        .scaleEffect(0.8)
                        .offset(x: 0, y: -90)

                    CardView(opacity: 0.5, toDo: toDos.first!)
                        .scaleEffect(0.9)
                        .offset(x: 0, y: -45)

                    CardView(toDo: toDos.first!)
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
    obj1.location = "Stack"
    
    let obj2 = ToDo(context: mc)
    obj2.title = "dos"
    obj2.createdAt = Date()
    obj1.location = "Stack"

    
    let obj3 = ToDo(context: mc)
    obj3.title = "tres"
    obj3.createdAt = Date()
    obj1.location = "Stack"

    
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
