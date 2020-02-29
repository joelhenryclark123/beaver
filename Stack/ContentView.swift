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
                .offset(y: state.dragState.storeTranslation.height + state.currentScene.storeOffset)
                .opacity(state.currentScene == .stack ? 0.5 : 1.0)
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
                            if value.translation.height <= -10 {
                                self.state.dragState = .draggingStore(translation: value.translation)
                            }
                        case .store:
                            if value.translation.height >= 10 {
                                self.state.dragState = .draggingStore(translation: value.translation)
                            }
                        }
                    case .draggingStore(_):
                        switch self.state.currentScene {
                        case .stack:
                            if value.translation.height <= 0 {
                                self.state.dragState = .draggingStore(translation: value.translation)                            }
                        case .store:
                            if value.translation.height >= 0 {
                                self.state.dragState = .draggingStore(translation: value.translation)                            }
                        }
                    default:
                        break
                    }
                })
                .onEnded({ (value) in
                    switch self.state.currentScene {
                    case .stack:
                        if value.translation.height <= -20 {
                            self.state.currentScene = .store
                        }
                    case .store:
                        if value.translation.height >= 20 {
                            self.state.currentScene = .stack
                        }
                    }
                    
                    self.state.dragState = .inactive
                }))
            .animation(.easeOut)
        
    }
}

//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
