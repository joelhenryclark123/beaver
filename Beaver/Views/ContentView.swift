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
    var color: FocalistColor
    
    var body: some View {
        Rectangle()
            .fill(
        LinearGradient(
            gradient: buildGradient(color: color),
            startPoint: .top,
            endPoint: .bottom
        )
        ).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    @FetchRequest(fetchRequest: ToDo.todayListFetch) var toDos: FetchedResults<ToDo>
    @EnvironmentObject var state: AppState
    
    enum Scene {
        case beginning
        case middle
        case end
        
        var color: FocalistColor {
            switch self {
            case .beginning:
                return .accentPink
            case .middle:
                return .backgroundBlue
            case .end:
                return .accentGreen
            }
        }
    }
    
    var scene: Scene {
        if toDos.count < 4 { return .beginning }
        else if !(toDos.allSatisfy({ $0.isArchived })) { return .middle }
        else { return .end }
    }
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground(color: scene.color)
                .transition(AnyTransition.opacity.animation(.linear))
                .zIndex(0)
            
            AddBar(color: scene.color)
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(2)
                .padding()
            
            if self.state.hasOnboarded == false {
                Onboarding()
                    .transition(
                        AnyTransition.move(edge: .bottom)
                            .combined(with: .offset(x: 0, y: 100)
                    ))
                    .animation(.spring())
                    .zIndex(3)
            }
            
            if self.scene == .beginning {
                StoreView()
                .frame(maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.spring()))
                    .zIndex(1.3)
            }
            
            if self.scene == .middle {
                DayView(toDos: toDos)
                .transition(AnyTransition.scale.animation(.spring()))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .zIndex(1.2)
            }
            
            if self.scene == .end {
                DoneView()
                    .zIndex(1.1)
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
//        
//                let _ = ToDo(
//                    context: mc,
//                    title: "Walk 400 miles",
//                    isActive: true
//                )
        
        return mc
    }()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, demoContext)
            .environmentObject(AppState())
    }
}
