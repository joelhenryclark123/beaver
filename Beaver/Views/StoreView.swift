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
        fetchRequest: ToDo.storeFetchRequest
    ) var toDos: FetchedResults<ToDo>
    @EnvironmentObject var state: AppState
    
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
        state.refresh()
        state.upToDate = true
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .bottom) {
                    Text("Build Your Day")
                        .modifier(FocalistFont(font: .heading4))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("select or add 4 items")
                        .modifier(FocalistFont(font: .caption))
                        .foregroundColor(.white)
                    }.padding(.top)
                    .padding(.horizontal)
                
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
            
            if selection.count == 4 {
                WideButton(.green, "Start Day") {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.startDay()
                    }
                }.padding()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
            }
        }
        .modifier(StoreStyle())
        .transition(.move(edge: .bottom))
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
            AddBar()
                .environment(\.managedObjectContext, context)
                .padding()
                
            StoreView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
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
            .frame(maxWidth: 500)
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
