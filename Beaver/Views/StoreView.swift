//
//  StoreView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAnalytics
import Combine

struct StoreView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        fetchRequest: ToDo.storeFetch
    ) var toDos: FetchedResults<ToDo>
    @State var refreshing: Bool = false
        
    var selectionCount: Int {
        let selected = toDos.filter { $0.isActive }
        return selected.count
    }
    
    func startDay() {
        for toDo in toDos { if toDo.isActive { toDo.moveToDay() } }
        try? context.save()
        
        #if DEBUG
        #else
        Analytics.logEvent("startedDay", parameters: nil)
        #endif
    }
    
    var emptyState: some View {
        VStack {
            VStack {
                Text("Empty!")
                    .modifier(FocalistFont(font: .heading1))
                Text("Tap the add bar above to get started")
                    .modifier(FocalistFont(font: .mediumText))
            }.foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    var instruction: String = "Tap the things you want to do today!"
    
    // MARK: Body
    var body: some View {
        ZStack {
            if toDos.isEmpty {
                emptyState
                    .transition(.identity)
                    .zIndex(0)
            }
            
            else {
                List {
                    Spacer().frame(height: 60)
                        .listRowBackground(EmptyView())

                    Text(instruction)
                        .listRowBackground(EmptyView())
                        .foregroundColor(Color("dimWhite"))
                        .animation(nil)

                    ForEach(self.toDos) { toDo in
                        StoreItem(toDo: toDo)
                        .transition(.identity)
                    }.onDelete { (offsets) in
                        for index in offsets {
                            self.toDos[index].delete()
                        }
                    }.listRowBackground(EmptyView())


                    Spacer()
                        .frame(height: 64)
                        .listRowBackground(EmptyView())
                }
                .zIndex(1)
            }

            if selectionCount >= 1 {
                WideButton(.backgroundBlue, "Start Day") {
                    self.startDay()
                }.zIndex(2)
            }
            
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
            let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let toDos = try! mc.fetch(ToDo.fetchRequest())
                    for toDo in toDos {
                        (toDo as! ToDo).delete()
                    }
                    
                    let _ = ToDo(
                        context: mc,
                        title: "Walk 100 miles",
                        isActive: false
                    )
        
                    let _ = ToDo(
                        context: mc,
                        title: "Walk 200 miles",
                        isActive: true
                    )
    
                    let _ = ToDo(
                        context: mc,
                        title: "Walk 300 miles",
                        isActive: true
                    )
    
                    let _ = ToDo(
                        context: mc,
                        title: "Walk 400 miles",
                        isActive: true
                    )
                    
                    return mc
        }()
    
    static let state = AppState(moc: context)
    
    static var previews: some View {
        ZStack {
            MainBackground()
                .environmentObject(state)

            ZStack {
                StoreView()
                    .environment(\.managedObjectContext, context)
                    .frame(maxHeight: .infinity)
                
                AddBar()
                    .environmentObject(state)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
