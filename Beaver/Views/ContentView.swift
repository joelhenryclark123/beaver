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
    var body: some View {
        LinearGradient(
            gradient: buildGradient(color: .backgroundBlue),
            startPoint: .top,
            endPoint: .bottom
        ).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @FetchRequest(fetchRequest: ToDo.todayListFetch) var toDos: FetchedResults<ToDo>
    @EnvironmentObject var state: AppState

    var showingStore: Bool {
        if toDos.count == 4 { return false }
        else { return true }
    }
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .zIndex(0)
            
            AddBar(upToDate: toDos.count == 4)
            .frame(maxHeight: .infinity, alignment: .top)
            .zIndex(1)
            .padding()
            
            if self.state.hasOnboarded == false {
                Onboarding()
                    .transition(
                        AnyTransition.move(edge: .bottom)
                            .combined(with: .offset(x: 0, y: 100)
                    ))
                    .animation(.spring())
                    .zIndex(4)
            }
                
            else {
                VStack {
                    if showingStore {
                        StoreView()
                            .frame(maxHeight: .infinity)
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .offset(x: 0, y: 100)))
                            .animation(.spring())
                            .padding(.top, 88)
                            .zIndex(3)
                    } else {
                        DayView(toDos: toDos)
                            .transition(AnyTransition.scale.animation(.spring()))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .zIndex(2)
                    }
                }.zIndex(3)
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .receive(on: RunLoop.main)) { (_) in self.toDos.forEach( { $0.moveToStore() } ) }
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
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, demoContext)
            .environmentObject(AppState())
    }
}
