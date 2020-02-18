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
    
    var body: some View {
        ZStack {
            if self.currentScene == .stack {
                Color("stackBackgroundColor")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Group {
                    if self.currentScene == .stack {
                        StackView()
                            .environment(\.managedObjectContext, context)
                            .padding(.horizontal, 10)
                            .padding(.top, 20)
                    }
                    else if self.currentScene == .store {
                        StoreView()
                    }
                }.animation(.spring())
                
                Footer(currentScene: $currentScene)
                    .padding(.top,20)
            }
            
        }
    }
}

enum Scene {
    case stack
    case store
}

struct CreatorModal: View {
    @State var typing: String = ""
    @Binding var adding: Bool
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        TextField("New ToDo", text: $typing, onCommit: {
            let newToDo = ToDo(context: self.context)
            newToDo.title = self.typing
            newToDo.completedAt = nil
            newToDo.createdAt = Date()
            
            do {
                try self.context.save()
            } catch {
                assert(false, "Error saving context")
            }
            
            self.adding.toggle()
        }).multilineTextAlignment(.center)
    }
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
