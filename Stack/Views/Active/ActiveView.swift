//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData


struct ActiveView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: ToDo.activeFetchRequest) var toDos: FetchedResults<ToDo>
    
    @State var newToDoTitle: String = ""
    
    var emptyState: some View {
        VStack(spacing: 0) {
            Text("Nothing to do!")
                .font(.system(size: 34))
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
            
            CustomTextField(
                placeholder: Text("New Item").foregroundColor(.white),
                text: $newToDoTitle,
                commit: {
                    if self.newToDoTitle.isEmpty {
                        return
                    } else {
                        let _ = ToDo(
                            context: self.context,
                            title: self.newToDoTitle,
                            isActive: true
                        )
                                                
                        self.newToDoTitle = ""
                    }
                }
                ).padding().frame(maxWidth: 500)
                        
        }
    }
    
    var body: some View {
        Group {
            if toDos.isEmpty {
                emptyState
            }
            else {
                VStack(spacing: 32) {
                    RoundedRectangle(cornerRadius: 38.5, style: .continuous)
                        .modifier(SoftBlueShadow())
                        .aspectRatio(1.0, contentMode: .fit)
                        .foregroundColor(Color.white)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 38.5,
                                style: .continuous
                            ).stroke(
                                Color("stackBackgroundColor"),
                                lineWidth: 10
                            )
                        )
                        .overlay (
                            Group {
                                Text(toDos.first!.title)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 40))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("stackBackgroundColor"))
                            }.padding(10)
                    ).scaleEffect()
                    
                    Button(action: { self.toDos.first!.complete() }) {
                        RoundedRectangle(cornerRadius: 39.5, style: .continuous)
                            .modifier(SoftBlueShadow())
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 38.5,
                                    style: .continuous
                                ).stroke(
                                    Color("stackBackgroundColor"),
                                    lineWidth: 10
                            ))
                            .overlay(
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .foregroundColor(Color("stackBackgroundColor"))
                                    .padding(25)
                        )
                    }.frame(width:100, height: 100)
                }.padding(16)
            }
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ActiveView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }
    }
}

struct SoftBlueShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color(UIColor(red: 0.14, green: 0.696, blue: 1, alpha: 1)),
                radius: 14, x: -5, y: -8
        )
            .shadow(
                color: Color(UIColor(red: 0, green: 0.556, blue: 0.86, alpha: 1)),
                radius: 14, x: 8, y: 5
        )
    }
    
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.frame(maxWidth: .infinity)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .foregroundColor(Color.white)
                .accentColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .frame(height: 42)
                        .foregroundColor(Color.white)
                        .opacity(0.3)
                )
        }
        .multilineTextAlignment(.center)
    }
}
