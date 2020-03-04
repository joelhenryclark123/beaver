//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct MainBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color("backgroundBlueDark"),
                Color("backgroundBlueLight"),
            ]), startPoint: .bottom, endPoint: .top
        ).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: ToDo.fetchMostRecent) var mostRecent: FetchedResults<ToDo>
    
    var upToDate: Bool {
        if mostRecent.isEmpty { return false }
        else if mostRecent.allSatisfy({ (toDo) -> Bool in
            if toDo.movedToday {
                return true
            } else {
                self.mostRecent.forEach({
                    $0.store()
                })
                return false
            }
        }) { return true }
        else {
            return false
        }
    }
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .zIndex(0)
            
            VStack {
                AddBar()
                    .padding()
                if upToDate {
                    DayView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(3)
                } else {
                    StoreView()
                        .frame(maxHeight: .infinity)
                        .zIndex(2)
                }
            }
                            
            if self.state.hasOnboarded == false {
                Onboarding()
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity)
                    .zIndex(3)
            }
        }
    }
}

//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
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
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
