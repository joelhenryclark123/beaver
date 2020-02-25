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
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var state: AppState
    
    @State var currentScene: Scene = .store
    @State var dragState: DragState = .inactive
        
    //MARK: Body
    var body: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StoreView()
            .offset(x: dragState.scrollTranslation.width + currentScene.storeOffset)
            
            StackView()
                .offset(x: dragState.scrollTranslation.width + currentScene.stackOffset)
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, state.footerHeight)
            
            VStack {
                Spacer()
                
                Footer(currentScene: $currentScene)
            }
        }.gesture(
            //MARK: Gestures
            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onChanged({ value in
                    /*
                     .inactive interprets the current drag using if statements,
                     and reassigns self.dragState to a case representing desired app behavior
                     */
                    switch self.dragState {
                    case .inactive:
                        switch self.currentScene {
                        case .stack:
                            if value.translation.width <= -10 {
                                self.dragState = .draggingSideways(translation: value.translation)
                            }
                        case .store:
                            if value.translation.width >= 10 {
                                self.dragState = .draggingSideways(translation: value.translation)
                            }

                        }
                    case .draggingSideways(_):
                        self.dragState = .draggingSideways(translation: value.translation)
                    case .checkingOff(_):
                        self.dragState = .checkingOff(translation: value.translation)
                    }
                })
                .onEnded({ (value) in
                    switch self.currentScene {
                    case .stack:
                        if value.translation.width >= 20 {
                            self.currentScene = .store
                        }
                    case .store:
                        if value.translation.width <= -20 {
                            self.currentScene = .stack
                        }
                    }
                    
                    // Reset dragState
                    self.dragState = .inactive
                }))
            .animation(.easeOut)
        
    }
}

enum Scene {
    case stack
    case store
    
    var stackOffset: CGFloat {
        switch self {
        case .stack:
            return CGFloat.zero
        case .store:
            return UIScreen.main.bounds.width
        }
    }
    
    var storeOffset: CGFloat {
        switch self {
        case .store:
            return CGFloat.zero
        case .stack:
            return -1 * UIScreen.main.bounds.width
        }
    }
}

enum DragState {
    case inactive
    case draggingSideways(translation: CGSize)
    case checkingOff(translation: CGSize)
    
    var scrollTranslation: CGSize {
        switch self {
        case .inactive, .checkingOff(_):
            return .zero
        case .draggingSideways(let translation):
            return translation
        }
    }
    
    var checkingTranslation: CGSize {
        switch self {
        case .inactive, .draggingSideways(_):
            return .zero
        case .checkingOff(let translation):
            return translation
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // Import ManagedObjectContext
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        mc.reset()
        
        let obj1 = ToDo(context: mc)
        obj1.title = "uno"
        obj1.createdAt = Date()
        obj1.location = "Store"
        
//        let obj2 = ToDo(context: mc)
//        obj2.title = "dos"
//        obj2.createdAt = Date()
//        obj2.location = "Stack"
//
//
//        let obj3 = ToDo(context: mc)
//        obj3.title = "tres"
//        obj3.createdAt = Date()
//        obj3.location = "Stack"
        
        
        mc.insert(obj1)
//        mc.insert(obj2)
//        mc.insert(obj3)
        
        return mc
    }()
    
    static let state = AppState()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(state)
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
                self.colorScheme == .light) ? Color.black : Color.white)
            
            Spacer()
            
            Button(action: {
                self.currentScene = .stack
            }) {
                Image(systemName: "square.stack.fill")
                    .foregroundColor((
                        (currentScene == .store) &&
                            self.colorScheme == .light) ? Color.black : Color.white)
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
