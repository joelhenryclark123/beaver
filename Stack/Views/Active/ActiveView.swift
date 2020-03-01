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
    
    @GestureState var dragLocation: CGPoint? = nil

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
            Spacer().frame(height: 64)
        }
    }
    
    var body: some View {
        Group {
            if toDos.isEmpty {
                emptyState
            }
            else {
                GeometryReader { geometry in
                    ZStack {
                        CardView(toDo: self.toDos.first!)
                            .padding()
                            .position(self.dragLocation == nil ? geometry.center : self.dragLocation!)
                        
                        Group {
                            if self.state.currentScene == .draggingActive {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .foregroundColor(Color.green)
                                        .position(
                                            x: geometry.center.x,
                                            y: geometry.size.height * 0.1
                                        )
                            }
                        }
                    }.gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .updating(self.$dragLocation, body: { (value, state, transaction) in
                                self.state.currentScene = .draggingActive
                                state = value.location
                            }).onEnded({ (value) in
                                self.state.currentScene = .active
                                if value.location.y <= (geometry.size.height * 0.1 + 32) &&
                                    value.location.x >= (geometry.center.x - 32) &&
                                    value.location.x <= (geometry.center.x + 32) {
                                    self.toDos.first!.complete()
                                }
                            })
                    )
                }
            }
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let _ = ToDo(
            context: mc,
            title: "Walk 100 miles",
            isActive: true
        )
        
        return mc
    }()
    
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
