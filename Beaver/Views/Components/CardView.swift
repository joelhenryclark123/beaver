//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var state: AppState
    @ObservedObject var toDo: ToDo
    
    @State var editingToDo: Bool = false
    
    @State var pressing: Bool = false
    @State var toDoIsAssignment: Bool = false
    @State var topLine: String = ""
    @State var bottomLine: String = ""
    
    static let cornerRadius: CGFloat = 40
    
    func handleTap() {
        if self.state.scene == .beginning {
            self.toDo.activeToggle()
        } else {
            self.toDo.completeToggle()
        }
    }
    
    var background: some View {
        Group {
            if toDo.isComplete {
                RoundedRectangle(cornerRadius: CardView.cornerRadius, style: .continuous)
                    .foregroundColor(Color("otherBlue"))
                    .overlay(
                        RoundedRectangle(cornerRadius: CardView.cornerRadius)
                            .stroke(Color("otherBlue").opacity(0.0), lineWidth: 4)
                            .modifier(FocalistShadow(option: .light))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: CardView.cornerRadius))
            }
            else {
                RoundedRectangle(cornerRadius: CardView.cornerRadius, style: .continuous)
                    .foregroundColor(Color("accentWhite"))
                    .modifier(FocalistShadow(option: .light))
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            background
            if !self.toDo.isComplete {
                VStack(spacing: 8) {
                    if toDoIsAssignment {
                        Text(topLine)
                            .modifier(FocalistFont(font: .reallySmallText))
                            .foregroundColor(Color("blackText").opacity(0.6))
                    }
                    
                    Text(self.toDo.title)
                        .modifier(FocalistFont(font: .mediumText))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    if toDoIsAssignment {
                        Text(bottomLine)
                            .modifier(FocalistFont(font: .reallySmallText))
                            .foregroundColor(Color("blackText").opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
                .zIndex(3)
                .transition(.opacity)
                .padding(8)
            } else {
                Image(systemName: "checkmark")
                    .resizable()
                    .padding(32)
                    .scaledToFit()
                    .foregroundColor(Color("dimWhite"))
                    .transition(.scale)
                    .zIndex(4)
            }
        }
        .modifier(BouncePressWithHold(handleTap: {
            self.handleTap()
        }, handleLongPress: {
            return
        }))
        .aspectRatio(1.0, contentMode: .fit)
        .contextMenu(toDo.isComplete ? nil : ContextMenu(menuItems: {
            Button(action: {
                editingToDo = true
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }
            
            Button(action: {
                toDo.delete()
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
            
            Button(action: {
                toDo.moveToStore()
            }) {
                Text("Finish Later")
                Image(systemName: "moon.fill")
            }
            
            Button(action: {
                toDo.toggleFocus()
            }) {
                Text("Focus")
                Image(systemName: "eyes")
            }
        }))
        .fullScreenCover(isPresented: $editingToDo, content: {
            EditorView(toDo: toDo, showing: $editingToDo)
        })
        .scaleEffect(self.pressing ? 0.8 : 1.0)
        .onAppear(perform: {
            if let assignment = toDo as? CanvasAssignment {
                topLine = assignment.course!.name!
                if assignment.dueDate != nil {
                    bottomLine = "Due " + assignment.mmddDueDate!
                }
                toDoIsAssignment = true
            }
        })
        .transition(.opacity)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static let toDo = ToDo(context: PreviewHelper.moc, title: "Sup", isActive: true)
//
//    static var previews: some View {
//        ZStack {
//            LinearGradient(
//                gradient: buildGradient(color: .otherBlue),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//                .edgesIgnoringSafeArea(.all)
//
//            PreviewHelper.demoAddBar
//
//            CardView(toDo: toDo)
//            .padding()
//        }
//    }
//}
