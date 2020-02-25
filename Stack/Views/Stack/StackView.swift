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
        predicate: NSPredicate(
            format: "(completedAt == nil) AND (location = 'Stack')"
        )
    ) var toDos: FetchedResults<ToDo>
    
    var saveBoundary: CGFloat = -200
        
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
                CardView(toDo: self.toDos[0])
            }
        }
    }
}

struct StackView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        mc.reset()
        
        let obj1 = ToDo(context: mc)
        obj1.title = "uno"
        obj1.createdAt = Date()
        obj1.movedAt = obj1.createdAt
        obj1.location = "Stack"
        
//        let obj2 = ToDo(context: mc)
//        obj2.title = "dos"
//        obj2.createdAt = Date()
//        obj2.movedAt = obj2.createdAt
//        obj2.location = "Stack"
//
//
//        let obj3 = ToDo(context: mc)
//        obj3.title = "tres"
//        obj3.createdAt = Date()
//        obj3.movedAt = obj3.createdAt
//        obj3.location = "Stack"
        
        
        mc.insert(obj1)
//        mc.insert(obj2)
//        mc.insert(obj3)
        
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
