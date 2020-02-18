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
    @State var currentScene: Scene = .stack
    @State var screenPosition = CGSize.zero
    @GestureState var dragOffset = CGSize.zero
    
    let screen = UIScreen.main.bounds
    let footerHeight: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StackView()
                .offset(x: self.screenPosition.width + self.dragOffset.width)
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, footerHeight)
            
            StoreView()
                .offset(x: screen.width + self.screenPosition.width + self.dragOffset.width)
            VStack {
            Spacer()
                
            Footer(currentScene: $currentScene)
            }
        }.gesture(DragGesture().updating($dragOffset, body: { (value, state, tx) in
            // stack going to store
            if self.currentScene == .stack && value.translation.width <= -10 {
                state = value.translation
            }
            // stack checking off
            else if self.currentScene == .stack && value.translation.height <= -10 {
                //TODO: Checkoff action
                print("Check off!!")
            }
            
            // store going to stack
            else if self.currentScene == .store && value.translation.width >= 10 {
                state = value.translation
            }
        }).onEnded({ (value) in
            //stack to store
            if value.translation.width <= -50 && self.currentScene == .stack {
                self.screenPosition.width = -1*self.screen.width
                self.currentScene = .store
            }
            //store to stack
            else if value.translation.width >= 50 && self.currentScene == .store {
                self.screenPosition = CGSize.zero
                self.currentScene = .stack
            }
        })).animation(.easeOut)
        
    }
}

enum Scene {
    case stack
    case store
}

struct ContentView_Previews: PreviewProvider {
    // Import ManagedObjectContext
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let obj1 = ToDo(context: mc)
        obj1.title = "uno"
        obj1.createdAt = Date()
        obj1.location = "Store"
        
        let obj2 = ToDo(context: mc)
        obj2.title = "dos"
        obj2.createdAt = Date()
        obj2.location = "Stack"
        
        
        let obj3 = ToDo(context: mc)
        obj3.title = "tres"
        obj3.createdAt = Date()
        obj3.location = "Stack"
        
        
        mc.insert(obj1)
        mc.insert(obj2)
        mc.insert(obj3)
        
        return mc
    }()
    
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, context)
    }
}

struct TargetButton: View {
    var diameter: CGFloat = 50.0
    var stroke: CGFloat = 2.5
    var strokeColor: Color = .orange
    var insideColor: Color = Color("systemBackgroundColor")
    var height: CGFloat = 1.0
    
    var innerDiameter: CGFloat {
        diameter - 2 * stroke
    }
    
    var sfSymbol: String = "plus"
    
    var glyph: Image {
        Image(systemName: sfSymbol)
    }
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: self.action) {
                Circle()
                    .frame(width: diameter, height: diameter)
                    .foregroundColor(strokeColor)
                    .overlay(
                        Circle()
                            .frame(width: innerDiameter, height: innerDiameter)
                            .foregroundColor(insideColor)
                )
                    .shadow(radius: height)
                    .overlay(glyph.foregroundColor(strokeColor))
                    .padding()
            }
        }
    }
}

struct Footer: View {
    @Binding var currentScene: Scene
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "lightbulb")
                .hidden()
                .scaleEffect((self.currentScene == .stack) ? 1.5 : 2.0)
            
            Spacer()
            
            Button(action: {
                self.currentScene = .stack
            }) {
                Image(systemName: "square.stack.fill")
                    .foregroundColor(
                        (self.currentScene == .store &&
                            self.colorScheme == .light) ? Color.black : Color.white)
            }.scaleEffect((self.currentScene == .stack) ? 2.0 : 1.5)                    .animation(.spring())
            
            Spacer()
            
            Button(action: {
                self.currentScene = .store
            }) {
                Image(systemName: "lightbulb")
                    .foregroundColor((self.currentScene == .store &&
                        self.colorScheme == .light) ? Color.black : Color.white)
            }
            .scaleEffect((self.currentScene == .stack) ? 1.5 : 2.0)
            .animation(.spring())
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 20)
    }
}
