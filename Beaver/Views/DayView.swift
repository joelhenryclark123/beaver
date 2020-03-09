//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAnalytics


struct DayView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: ToDo.dayFetchRequest) var toDos: FetchedResults<ToDo>
    
    var allComplete: Bool {
        self.toDos.allSatisfy({ $0.isComplete })
    }
    
    func completeDay() -> Void {
        for toDo in self.toDos {
            toDo.isActive = false
        }
        
        try! self.context.save()
        
        Analytics.logEvent("completedDay", parameters: nil)
    }
        
    var body: some View {
        ZStack {
            if toDos.isEmpty {
                VStack {
                    Text("Done!")
                        .modifier(FocalistFont(font: .heading1))
                        .foregroundColor(.white)
                    Text("Come back tomorrow")
                        .modifier(FocalistFont(font: .mediumText))
                        .foregroundColor(.white)
                }
            }
            else if toDos.count == 4 {
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
                
                if (self.allComplete) {
                    WideButton(.white, "Complete") {
                        withAnimation(.easeIn(duration: 0.2)) {
                            self.completeDay()
                        }
                    }.padding(.horizontal)
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
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let toDos = try! mc.fetch(ToDo.fetchRequest())
                for toDo in toDos {
                    (toDo as! ToDo).delete()
                }
                
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
            
            DayView()
                .environment(\.managedObjectContext, context)
        }
    }
}
