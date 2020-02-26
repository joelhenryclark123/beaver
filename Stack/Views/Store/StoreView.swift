//
//  StoreView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StoreView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                key: "createdAt",
                ascending: true
            )
        ],
        predicate: NSPredicate(
            format: "(completedAt == nil) AND (location = 'Store')"
        )
    ) var toDos: FetchedResults<ToDo>
    
    @State var newToDoTitle: String = ""
    let footerHeight: CGFloat = 60
    
    var body: some View {
            NavigationView {
                VStack {
                    TextField("New", text: $newToDoTitle, onCommit: {
                        let newToDo = ToDo(context: self.context)
                        newToDo.title = self.newToDoTitle
                        newToDo.completedAt = nil
                        newToDo.createdAt = Date()
                        newToDo.location = "Store"
                        
                        do {
                            try self.context.save()
                            self.newToDoTitle = ""
                        } catch {
                            assert(false, "Error saving context")
                        }
                    })
                        .padding(.leading, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .frame(height: 42)
                                .foregroundColor(Color.gray)
                                .opacity(0.3)
                        )
                        .padding()
                    
                    List{
                        ForEach(toDos) { toDo in
                            StoreItem(toDo: toDo)
                        }.onDelete { (offsets) in
                            for index in offsets {
                                let toDo = self.toDos[index]
                                self.context.delete(toDo)
                                do {
                                    try self.context.save()
                                } catch {
                                    //TODO: Deal with this
                                }
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: footerHeight)
                }.navigationBarTitle("Ideas")
                    .navigationBarItems(trailing: EditButton().padding(.top, 100))
            }.navigationViewStyle(StackNavigationViewStyle()
            )
                .clipShape(RoundedRectangle(cornerRadius: 39.5, style: .continuous))
    }
}

struct StoreView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
    let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let obj1 = ToDo(context: mc)
    obj1.title = "uno"
    obj1.createdAt = Date()
    obj1.location = "Store"
    
    let obj2 = ToDo(context: mc)
    obj2.title = "dos"
    obj2.createdAt = Date()
    obj2.location = "Stack"

    
    let obj3 = ToDo(context: mc)
    obj3.title = "tres"
    obj3.createdAt = Date()
    obj3.location = "Store"

    
    mc.insert(obj1)
    mc.insert(obj2)
    mc.insert(obj3)
    
    return mc
    }()
    
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StoreView().environment(\.managedObjectContext, context)
        }
    }
}
