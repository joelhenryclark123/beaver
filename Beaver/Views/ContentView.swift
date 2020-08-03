//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @EnvironmentObject var state: AppState
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .zIndex(0)
            
            AddBar()
                .zIndex(6)

            if self.state.scene == .onboarding {
                Onboarding()
                    .transition(
                        AnyTransition.move(edge: .bottom)
                            .combined(with: .offset(x: 0, y: 100)
                    ))
                    .animation(.spring())
                    .zIndex(5)
            }
            else {
            if self.state.scene == .beginning {
                StoreView()
                    .transition(.storeTransition)
                    .animation(.spring())
                    .zIndex(4)
            }

            if ((self.state.scene == .middle) || (self.state.scene == .focusing)) {
                DayView()
                    .transition(.dayTransition)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .zIndex(3)
            }

            if self.state.scene == .end {
                DoneView()
                    .transition(AnyTransition.opacity.animation(.spring()))
                    .zIndex(2)
            }
                if self.state.scene == .attaching {
                    EmptyView()
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .receive(on: RunLoop.main)) { (_) in self.endDay() }
    }
    
    func endDay() {
        self.state.activeList.forEach({ $0.moveToStore() })
    }
}

//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static let demoContext: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
                let toDos = try! mc.fetch(ToDo.fetchRequest())
                for toDo in toDos {
                    (toDo as! ToDo).delete()
                }
        
                let list: [ToDo] = [
                    ToDo(
                        context: mc,
                        title: "Walk 100 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 200 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 300 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 400 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 500 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 600 miles",
                        isActive: false
                    ),
                    ToDo(
                        context: mc,
                        title: "Walk 700 miles",
                        isActive: false
                    )
                ]
        
        return mc
    }()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, demoContext)
            .environmentObject(AppState(moc: demoContext))
    }
}
