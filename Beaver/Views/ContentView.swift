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

struct MainBackground: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: buildGradient(color: state.scene.color),
                    startPoint: .top,
                    endPoint: .bottom
                )
        ).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @EnvironmentObject var state: AppState
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .transition(AnyTransition.opacity.animation(.linear))
                .zIndex(0)
            
            AddBar(color: state.scene.color)
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(6)
                .padding()

            if self.state.hasOnboarded == false {
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
            
            if self.state.scene == .middle {
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
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .receive(on: RunLoop.main)) { (_) in self.state.activeList.forEach( { $0.moveToStore() } ) }
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
        
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 100 miles",
//            isActive: true
//        )
//        
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 200 miles",
//            isActive: true
//        )
//        
//        let completed = ToDo(
//            context: mc,
//            title: "Walk 300 miles",
//            isActive: true
//        )
//        completed.completeToggle()
        
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 400 miles",
//            isActive: true
//        )
        
        return mc
    }()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, demoContext)
            .environmentObject(AppState(moc: demoContext))
    }
}
