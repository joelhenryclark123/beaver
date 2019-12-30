//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI

struct ToDo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var complete: Bool
}

struct ToDoView: View {
    var toDo: ToDo
    
    var body: some View {
        Text(toDo.title)
    }
}

var toDos: [ToDo] = []

struct ContentView: View {
    @State var adding: Bool = false
    @State var toDo: ToDo? = nil
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    TargetButton() {
                        self.adding.toggle()
                    }.sheet(isPresented: $adding) {
                        CreatorModal(adding: self.$adding, toDo: self.$toDo)
                    }
                }
                
                Spacer()
            }
            
            Group {
                if toDo != nil {
                    VStack {
                        Spacer()
                        
                        Text(toDo!.title)
                        
                        Spacer()
                        
                        Button(action: {
                            toDos.removeFirst()
                            
                            if !toDos.isEmpty {
                                self.toDo = toDos[0]
                            }
                            else {
                                self.toDo = nil
                            }
                        }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                else {
                    Text("Nothing to do!")
                }
            }
        }
    }
}

struct CreatorModal: View {
    @Binding var adding: Bool
    @Binding var toDo: ToDo?
    @State var tempName: String = ""
    
    var body: some View {
        VStack {
            TextField("New Todo", text: $tempName, onCommit: {
                toDos.append(ToDo(title: self.tempName, complete: false))
                
                if self.toDo == nil {
                    self.toDo = toDos[0]
                }
                
                self.adding.toggle()
            }).multilineTextAlignment(.center)
            
            Spacer()
        }.padding(.top, 20)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
