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
    // MARK: - Properties
    @EnvironmentObject var state: AppState
    @State var nudging: Bool = false
    
    var instruction: String = "Pick today's tasks"
    
    // MARK: - Views
    var body: some View {
        ZStack {
            if state.storeList.isEmpty {
                emptyState
                    .transition(.identity)
                    .zIndex(0)
            } else {
                VStack {
                    toDoListView
                }
            }
        }
    }
        
    var toDoListView: some View {
        List {
            VStack(alignment: .leading) {
                Text("Queue")
                    .font(.largeTitle).bold()
                    .foregroundColor(Color("accentWhite"))

                Text(instruction)
                    .foregroundColor(Color("dimWhite"))
                
            }.listRowBackground(EmptyView())
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
            
            ForEach(self.state.storeList) { toDo in
                StoreItem(toDo: toDo)
                    .listRowBackground(EmptyView())
            }.onDelete { (offsets) in
                for index in offsets {
                    state.deleteFromStore(index: index)
                }
            }
            .listRowBackground(EmptyView())
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
        }
        .listStyle(SidebarListStyle())
        .animation(.easeIn(duration: 0.2))
        .zIndex(1)
    }
    
    var emptyState: some View {
        VStack {
            VStack {
                Text("Empty!")
                    .modifier(FocalistFont(font: .heading1))
                Text("Tap the add button to get started")
                    .modifier(FocalistFont(font: .mediumText))
            }.foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
        
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 200 miles",
//            isActive: true
//        )
//
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 300 miles",
//            isActive: true
//        )
//
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 400 miles",
//            isActive: true
//        )
        
        return mc
    }()
    
    static let state = AppState(moc: context)
    
    static var previews: some View {
        ZStack {
            MainBackground()
                .environmentObject(state)
            
            ZStack {
                StoreView()
                    .environmentObject(state)
                    .frame(maxHeight: .infinity)
                
//                AddBar()
//                    .environmentObject(state)
//                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
