//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var adding: Bool = false
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)],
        predicate: NSPredicate(format: "completedAt == nil")
    ) var toDos: FetchedResults<ToDo>
    
    var emptyState: some View {
        VStack(spacing: 10) {
            Text("Empty")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .fontWeight(.light)
        }
    }
    
    
    var body: some View {
        ZStack {
            // Add Button
            TargetButton() {
                self.adding.toggle()
            }.sheet(isPresented: $adding) {
                CreatorModal(adding: self.$adding).environment(\.managedObjectContext, self.context)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            Group {
                if self.toDos.count == 0 {
                    emptyState
                }
                else {
                    ZStack {
                        Text(self.toDos.first!.title)
                        
                        TargetButton(height: 0, sfSymbol: "checkmark") {
                            self.toDos.first!.setValue(Date(), forKey: "completedAt")
                            print(self.toDos)
                            
                            do {
                                try self.context.save()
                            } catch {
                                print("ERROR SAVING")
                                assert(false)
                            }
                            print("Remove Top To Do")
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                }
            }
        }
    }
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
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
