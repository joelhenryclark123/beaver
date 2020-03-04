//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct DayView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: ToDo.activeFetchRequest) var toDos: FetchedResults<ToDo>
    
    func allComplete() -> Bool {
        self.toDos.allSatisfy({ $0.isComplete })
    }
    
    func completeDay() -> Void {
        for toDo in self.toDos {
            toDo.isActive = false
        }
        try! self.context.save()
    }
        
    var body: some View {
        ZStack {
            if toDos.first == nil {
                VStack {
                    Text("Done!")
                        .modifier(FocalistFont(font: .heading1))
                        .foregroundColor(.white)
                    Text("Come back tomorrow")
                        .modifier(FocalistFont(font: .mediumText))
                        .foregroundColor(.white)
                }
            }
            else {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        CardView(toDo: self.toDos[0])
                        CardView(toDo: self.toDos[1])
                    }
                    HStack(spacing: 16) {
                        CardView(toDo: self.toDos[2])
                        CardView(toDo: self.toDos[3])
                    }
                }.padding().transition(.opacity)
                
                if (self.allComplete()) {
                    WideButton(.white, "Complete") {
                        withAnimation(.easeIn(duration: 0.2)) {
                            self.completeDay()
                        }
                    }.padding()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                }
            }
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = ContentView_Previews.context
        
        return mc
    }()
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            DayView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }
    }
}
