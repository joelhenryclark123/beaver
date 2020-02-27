//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var state: AppState
    
    
    //MARK: Body
    var body: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ActiveView()
            
            StoreView()
                .zIndex(1)
                .offset(x: state.dragState.scrollTranslation.width + state.currentScene.storeOffset)
                .shadow(radius: 10)
                        
        }.gesture(
            //MARK: Gestures
            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onChanged({ (value) in
                    /*
                     .inactive interprets the current drag using if statements,
                     and reassigns self.dragState to a case representing desired app behavior
                     */
                    switch self.state.dragState {
                    case .inactive:
                        switch self.state.currentScene {
                        case .stack:
                            if value.translation.width <= -10 {
                                self.state.dragState = .draggingSideways(translation: value.translation)
                            }
                        case .store:
                            if value.translation.width >= 10 {
                                self.state.dragState = .draggingSideways(translation: value.translation)
                            }
                        }
                    case .draggingSideways(_):
                        switch self.state.currentScene {
                        case .stack:
                            if value.translation.width <= 0 {
                                self.state.dragState = .draggingSideways(translation: value.translation)
                            }
                        case .store:
                            if value.translation.width >= 0 {
                                self.state.dragState = .draggingSideways(translation: value.translation)
                            }
                        }
                    default:
                        break
                    }
                })
                .onEnded({ (value) in
                    switch self.state.currentScene {
                    case .stack:
                        if value.translation.width <= -20 {
                            self.state.currentScene = .store
                        }
                    case .store:
                        if value.translation.width >= 20 {
                            self.state.currentScene = .stack
                        }
                    }
                    
                    self.state.dragState = .inactive
                }))
            .animation(.easeOut)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    // Import ManagedObjectContext
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        mc.reset()
        
        let obj1 = ToDo(
            context: mc,
            title: "What if the moon was made of cheese",
            isActive: false
        )
                
        return mc
    }()
    
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}

struct Footer: View {
    @Binding var currentScene: Scene
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let screen = UIScreen.main.bounds
    
    var body: some View {
        HStack {
            Image(systemName: "lightbulb")
                .foregroundColor(((currentScene == .store) &&
                    self.colorScheme == .light) ? Color.white : Color.white)
                .scaleEffect((currentScene == .stack) ? 1.5 : 2.0)
            
            
            Spacer()
            
            Button(action: {
                self.currentScene = .stack
            }) {
                Image(systemName: "square.stack.fill")
                    .foregroundColor((
                        (currentScene == .store) &&
                            self.colorScheme == .light) ? Color.white : Color.white)
            }.scaleEffect((currentScene == .stack) ? 2.0 : 1.5)
                .animation(.spring())
            
            Spacer()
            
            Button(action: {
                self.currentScene = .store
            }) {
                Image(systemName: "lightbulb")
                    .hidden()
                    .scaleEffect((currentScene == .stack) ? 1.5 : 2.0)
            }
            .scaleEffect((currentScene == .stack) ? 1.5 : 2.0)
            .animation(.spring())
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 20)
    }
}
