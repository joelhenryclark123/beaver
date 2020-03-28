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
        Analytics.logEvent("startedDay", parameters: nil)
    }
    
    var emptyState: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("Empty!")
                    .modifier(FocalistFont(font: .heading1))
                Text("Tap the add bar above to get started")
                    .modifier(FocalistFont(font: .mediumText))
            }.foregroundColor(.white)
            
            Spacer()
        }
    }
    
    var instruction: String {
        let count = toDos.count
        if count < 4 {
            return "Add \(4 - count) more To-Dos!"
        } else {
            return "Tap four To-Dos to get started!"
        }
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack {
                if toDos.isEmpty { emptyState }
                    
                else {
                    List {
                        Spacer().frame(height: 84)
                        
                        ForEach(self.toDos) { toDo in
                            Button(action: {
                                toDo.activeToggle()
                            }) {
                            StoreItem(toDo: toDo)
                                .padding(0)
                            }
                        }.onDelete { (offsets) in
                            for index in offsets {
                                self.toDos[index].delete()
                            }
                        }.padding(0)
                        Spacer().frame(height: 64)
                    }
                }
            }.modifier(StoreStyle())

            if selectionCount == 4 {
                WideButton(.green, "Start Day") {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.startDay()
                    }
                }.padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
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
    //
    //                let _ = ToDo(
    //                    context: mc,
    //                    title: "Walk 200 miles",
    //                    isActive: true
    //                )
    //
    //                let _ = ToDo(
    //                    context: mc,
    //                    title: "Walk 300 miles",
    //                    isActive: true
    //                )
    //
    //                let _ = ToDo(
    //                    context: mc,
    //                    title: "Walk 400 miles",
    //                    isActive: true
    //                )
                    
                    return mc
        }()
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            ZStack {
                
                StoreView()
                    .environment(\.managedObjectContext, context)
                    .frame(maxHeight: .infinity)
                
                AddBar(upToDate: false)
                    .environment(\.managedObjectContext, context)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
            }
        }
    }
}

// MARK: Style
struct StoreStyle: ViewModifier {
    @EnvironmentObject var state: AppState
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
    }
}
