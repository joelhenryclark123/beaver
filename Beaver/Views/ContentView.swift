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
            gradient: Gradient(colors: [
                Color("backgroundBlueDark"),
                Color("backgroundBlueLight"),
            ]), startPoint: .bottom, endPoint: .top
        ).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @FetchRequest(fetchRequest: ToDo.todayListFetch) var toDos: FetchedResults<ToDo>
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .zIndex(0)

            VStack {
                AddBar(upToDate: true)
                    .padding()
                
                Text(String(toDos.count))
                
                if toDos.isEmpty {
                        StoreView()
                            .frame(maxHeight: .infinity)
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .offset(x: 0, y: 100)))
                            .animation(.spring())
                            .zIndex(3)
                } else {
                    DayView()
                        .transition(AnyTransition.scale.animation(.spring()))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(2)
                }
            }

            if self.state.hasOnboarded == false {
                Onboarding()
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .offset(x: 0, y: 100)))
                    .animation(.spring())
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
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
