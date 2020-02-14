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
        ZStack(alignment: .bottom) {
            Group {
                if self.currentScene == .stack {
                    //TODO: Revert
                    Color("stackBackgroundColor")
                        .edgesIgnoringSafeArea(.all)

                    StackView()
                        .environment(\.managedObjectContext, context)
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                }
            }
            
            Footer(currentScene: $currentScene)
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
    
    var body: some View {
        Group {
            if currentScene == .stack {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(Color.white)
                        .scaleEffect(1.5)
                    
                    Spacer()
                    
                    Image(systemName: "square.stack.fill")
                        .foregroundColor(Color.white)
                        .scaleEffect(2.0)
                    
                    Spacer()
                    
                    Image(systemName: "lightbulb")
                    .foregroundColor(Color("stackBackgroundColor"))
                    .scaleEffect(1.5)
                    
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 12)
            }
            else {
                Text("????????")
            }
        }
    }
}
