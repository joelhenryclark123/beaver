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
    @EnvironmentObject var store: ToDoStore
    
    var emptyState = Text("Nothing to do!")
    
    var body: some View {
        ZStack {
            TargetButton() {
                self.adding.toggle()
            }.sheet(isPresented: $adding) {
                CreatorModal(adding: self.$adding).environmentObject(self.store)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            Group {
                if self.store.topToDo != nil {
                    VStack {
                        Spacer()
                        Text(self.store.topToDo!.title)
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button(action: { self.store.checkTopToDo() }) {
                                Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .foregroundColor(Color.orange)

                            }.padding()
                        }
                    }
                }
                else {
                    emptyState
                }
            }
        }
    }
}

struct CreatorModal: View {
    @State var typing: String = ""
    @Binding var adding: Bool
    @EnvironmentObject var store: ToDoStore
    
    var body: some View {
        TextField("New ToDo", text: $typing, onCommit: {
            self.store.newToDo(ToDo(title: self.typing, complete: false))
            self.adding.toggle()
        }).multilineTextAlignment(.center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store = ToDoStore()
    static var previews: some View {
        ContentView().environmentObject(store)
    }
}

struct TargetButton: View {
    var diameter: CGFloat = 50.0
    var stroke: CGFloat = 2.5
    var strokeColor: Color = .orange
    var insideColor: Color = .white
    
    var innerDiameter: CGFloat {
        diameter - 2 * stroke
    }
    
    var glyph: Image = Image(systemName: "plus")
    
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
                    .shadow(radius: 1)
                    .overlay(glyph.foregroundColor(strokeColor))
                    .padding()
            }
        }
    }
}
