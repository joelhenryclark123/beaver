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
    @State var scene: Scene = .beginning
    @State var animating: Bool = true
    
    // Placeholder... never really appears
    @State var textAlert: TextAlert = TextAlert(title: "New To-Do", message: "New to-dos go to the backlog", accept: "Add", action: { string in
        return
    })
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground(scene: $state.scene)
                .zIndex(0)
            
            ZStack {
                switch scene {
                case .onboarding:
                    Onboarding()
                        .transition(.storeTransition)
                        .zIndex(5)
                case .beginning:
                    StoreView()
                        .transition(.storeTransition)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .zIndex(3)
                case .middle, .focusing:
                    DayView()
                        .transition(.dayTransition)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .zIndex(4)
                case .end:
                    DoneView()
                        .transition(AnyTransition.opacity.animation(.spring()))
                        .zIndex(2)
                case .attaching:
                    EmptyView()
                }
                
                VStack {
                    Spacer()
                    Footer(adding: $adding)
                }
                .edgesIgnoringSafeArea(.bottom)
                .zIndex(6)

            }
            .animation(.spring(), value: scene)
        }
        .onChange(of: self.state.scene, perform: { newValue in
            self.scene = newValue
            animating.toggle()
        })
        .onReceive(
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .receive(on: RunLoop.main)) { (_) in self.endDay() }
        .onAppear(perform: {
            self.scene = self.state.scene
            
            textAlert.action = { (string: String?) in
                DispatchQueue.main.async {
                    if let string = string {
                        self.state.createToDo(title: string, active: false)
                    }
                }
            }
        })
        .fullScreenCover(isPresented: $adding, content: {
            ToDoMakerView(showing: $adding)
        })
        .alert(isPresented: .constant(false), textAlert)
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
            (toDo).delete()
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
