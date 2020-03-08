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

struct StoreView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        fetchRequest: ToDo.storeFetchRequest
    ) var toDos: FetchedResults<ToDo>
    
    var selection: [ToDo] {
        let selected = toDos.filter { (toDo) -> Bool in
            toDo.isActive
        }
        
        return selected
    }
    
    func startDay() {
        for toDo in toDos {
            toDo.move()
        }
        
        try! context.save()
        
        Analytics.logEvent("startedDay", parameters: nil)
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack {
                if !toDos.isEmpty {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("Build Your Day")
                            .modifier(FocalistFont(font: .largeText))
                            .foregroundColor(.white)
                        
                        Text("Choose 4 To-Dos")
                            .modifier(FocalistFont(font: .caption))
                            .foregroundColor(.white)
                        }.padding(.top)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    EditButton()
                        .padding(.trailing)
                        .foregroundColor(.white)
                    }
                }
                
                if toDos.isEmpty {
                    VStack {
                        Spacer()
                        
                        VStack {
                            Text("Empty!")
                                .modifier(FocalistFont(font: .heading1))
                                .foregroundColor(.white)
                            Text("Tap the add bar above to get started")
                                .modifier(FocalistFont(font: .mediumText))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(self.toDos) { toDo in
                            StoreItem(toDo: toDo)
                                .transition(.identity)
                                .animation(.spring())
                            .padding(0)
                        }.onDelete { (offsets) in
                            for index in offsets {
                                self.toDos[index].delete()
                            }
                        }.padding(0)
                        Spacer().frame(height: 64)
                    }
                }
            }.modifier(StoreStyle())

            if selection.count == 4 {
                WideButton(.green, "Start Day") {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.startDay()
                    }
                }.padding(.horizontal)
                    .padding(.bottom, 16)
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
                    
    //                let _ = ToDo(
    //                    context: mc,
    //                    title: "Walk 100 miles",
    //                    isActive: true
    //                )
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
            
            VStack {
            AddBar(upToDate: false)
                .environment(\.managedObjectContext, context)
                .padding()
                
            StoreView()
                .environment(\.managedObjectContext, context)
                .frame(maxHeight: .infinity)
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
            .background(
                RoundedRectangle(
                    cornerRadius: 39.5,
                    style: .continuous).hidden()
                    .modifier(FocalistMaterial())
                    .clipShape(RoundedRectangle(cornerRadius: 39.5,
                                                style: .continuous))
        )
            .edgesIgnoringSafeArea(.bottom)
    }
}
