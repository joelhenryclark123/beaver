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
    @FetchRequest(fetchRequest: ToDo.todayListFetch) var toDos: FetchedResults<ToDo>
    
    func completeDay() -> Void {
        self.toDos.forEach({ $0.totallyFinish() })
        Analytics.logEvent("completedDay", parameters: nil)
    }
    
    var dayComplete: Bool {
        self.toDos.allSatisfy(
            {$0.completedAt != nil && $0.isActive == false}
        )
    }
    
    var emptyState: some View {
        VStack {
            Text("Done!")
                .modifier(FocalistFont(font: .heading1))
                .foregroundColor(.white)
            Text("Come back tomorrow")
                .modifier(FocalistFont(font: .mediumTextSemibold))
                .foregroundColor(.white)
            Text("(or save a task for later with the add bar)")
                .modifier(FocalistFont(font: .smallText))
                .foregroundColor(Color("dimWhite"))
        }
    }
        
    var body: some View {
        let showingButton: Bool = self.toDos.allSatisfy({ $0.completedAt != nil && $0.isActive == true })

        return ZStack {
            if (showingButton) {
                WideButton(.white, "Complete") {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.completeDay()
                    }
                }.padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                .zIndex(3)
            }
            Group {
            if dayComplete {
                emptyState.zIndex(1)
            } else {
                VStack(spacing: 16) {
                    #if DEBUG
                    Text("showingButton: \(String(showingButton))")
                    #endif
                    HStack(spacing: 16) {
                        CardView(toDo: self.toDos[0])
                        CardView(toDo: self.toDos[1])
                    }
                    HStack(spacing: 16) {
                        CardView(toDo: self.toDos[2])
                        CardView(toDo: self.toDos[3])
                    }
                }
                .padding()
                .zIndex(2)
                }
            }.transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
        }
    }
}

//struct ActiveView_Previews: PreviewProvider {
//    static let context: NSManagedObjectContext = {
//        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                
//                let toDos = try! mc.fetch(ToDo.fetchRequest())
//                for toDo in toDos {
//                    (toDo as! ToDo).delete()
//                }
//                
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
//                
//                return mc
//    }()
//    
//    static var previews: some View {
//        ZStack {
//            MainBackground()
//            
//            DayView()
//                .environment(\.managedObjectContext, context)
//        }
//    }
//}
