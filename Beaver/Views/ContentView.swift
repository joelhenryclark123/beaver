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
    @State var adding: Bool = false
    
    @State var textAlert: TextAlert = TextAlert(title: "New To-Do", message: "New to-dos go to the backlog", accept: "Add", action: { string in
        return
    })
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground()
                .zIndex(0)
            
            ZStack {
                if self.state.scene == .onboarding {
                    Onboarding()
                        .transition(.storeTransition)
                        .animation(.spring())
                        .zIndex(5)
                }
                else {
                    if self.state.scene == .beginning {
                        StoreView()
                            .transition(.storeTransition)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .animation(.spring())
                            .zIndex(4)
                    }
                    
                    if ((self.state.scene == .middle) || (self.state.scene == .focusing)) {
                        DayView()
                            .transition(.dayTransition)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .zIndex(3)
                    }
                    
                    if self.state.scene == .end {
                        DoneView()
                            .transition(AnyTransition.opacity.animation(.spring()))
                            .zIndex(2)
                    }
                }
                
                VStack {
                    Spacer()
                    Footer(adding: $adding)
                }
                .edgesIgnoringSafeArea(.bottom)
                .zIndex(6)

            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .receive(on: RunLoop.main)) { (_) in self.endDay() }
        .onAppear(perform: {
            textAlert.action = { (string: String?) in
                DispatchQueue.main.async {
                    if let string = string {
                        self.state.createToDo(title: string, active: false)
                    }
                }
            }
        })
        .alert(isPresented: $adding, textAlert)
        .edgesIgnoringSafeArea(.all)
    }
    
    func endDay() {
        self.state.refresh(newFetch: true)
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
                isActive: true
            ),
            ToDo(
                context: mc,
                title: "Walk 700 miles",
                isActive: true
            )
        ]
        
        return mc
    }()
    
    static let state: AppState = {
        let state = AppState(moc: demoContext)
        state.startDay()
        return state
    }()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, demoContext)
            .environmentObject(AppState(moc: demoContext))
    }
}
