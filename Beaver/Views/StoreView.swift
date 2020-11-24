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
    
    var instruction: String = "Pick what you want to do today!"
    
    // MARK: - Views
    var body: some View {
        ZStack {
            if nudging {
                WideButton(.backgroundBlue, "Start Day") {
                    self.state.startDay()
                }
                .zIndex(2)
            }
            
            if state.storeList.isEmpty {
                emptyState
                    .transition(.identity)
                    .zIndex(0)
            } else {
                VStack {
                    toDoListView
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange), perform: { _ in
            if state.storeList.contains(where: { $0.isActive }) {
                self.nudging = true
            } else {
                self.nudging = false
            }
        })
    }
        
    var toDoListView: some View {
        List {
            Text(instruction)
                .listRowBackground(EmptyView())
                .foregroundColor(Color("dimWhite"))
            
            ForEach(self.state.storeList) { toDo in
                StoreItem(toDo: toDo)
            }.onDelete { (offsets) in
                for index in offsets {
                    state.deleteFromStore(index: index)
                }
            }
            .listRowBackground(EmptyView())
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))

            Spacer()
                .frame(height: 10)
                .listRowBackground(EmptyView())
        }
        .listStyle(SidebarListStyle())
        .padding(.top, 25)
        .animation(.easeIn(duration: 0.2))
        .zIndex(1)
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
}

struct StoreView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let toDos = try! mc.fetch(ToDo.fetchRequest())
        for toDo in toDos {
            (toDo as! ToDo).delete()
        }
        
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 100 miles",
//            isActive: false
//        )
        
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
                
                AddBar()
                    .environmentObject(state)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
