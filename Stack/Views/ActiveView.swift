//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData


struct ActiveView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: ToDo.activeFetchRequest) var toDos: FetchedResults<ToDo>
        
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    CardView(toDo: self.toDos[0])
                    CardView(toDo: self.toDos[1])
                }
                HStack(spacing: 16) {
                    CardView(toDo: self.toDos[2])
                    CardView(toDo: self.toDos[3])
                }
            }.padding()
            
            if (toDos[0].completedAt != nil) &&
                (toDos[1].completedAt != nil) &&
                (toDos[2].completedAt != nil) &&
                (toDos[3].completedAt != nil) {
            WideButton(.white, "Complete") {
                print("SUP")
                }.padding()
            .frame(maxHeight: .infinity, alignment: .bottom)
            .transition(.move(edge: .bottom))
                .animation(.spring())
            }
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = ContentView_Previews.context
        
        let _ = ToDo(
            context: mc,
            title: "Walk 100 miles",
            isActive: true
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
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            ActiveView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }
    }
}
