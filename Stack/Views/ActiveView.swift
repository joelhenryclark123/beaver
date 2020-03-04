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
    
    var body: some View {
        Group {
            if toDos.isEmpty {
                EmptyState()
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
                                    .background(Circle().foregroundColor(Color.white))
                                    .position(
                                        x: geometry.center.x,
                                        y: geometry.size.height * 0.1
                                )
                                Image(systemName: "tray.and.arrow.down.fill")
                                    .resizable()
                                    .padding()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(Color.black)
                                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(Color.white))
                                    .position(
                                        x: geometry.center.x,
                                        y: geometry.size.height * 0.9
                                )
                            }
                        }
                    }.gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .updating(self.$dragLocation, body: { (value, state, transaction) in
                                self.state.currentScene = .draggingActive
                                state = value.location
                            }).onEnded({ (value) in
                                if value.location.y <= (geometry.size.height * 0.1 + 32) &&
                                    value.location.x >= (geometry.center.x - 32) &&
                                    value.location.x <= (geometry.center.x + 32) {
                                    self.toDos.first!.complete()
                                }
                                
                                if value.location.y >= (geometry.size.height * 0.9 - 32) &&
                                    value.location.x >= (geometry.center.x - 32) &&
                                    value.location.x <= (geometry.center.x + 32) {
                                    self.toDos.first!.store()
                                }
                                self.state.currentScene = .active
                            })
                    )
                }
            }
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = ContentView_Previews.context
        
        let _ = ToDo(
            context: mc,
            title: "Walk 100 miles",
            isActive: true
        )
        
        return mc
    }()
    
    static var previews: some View {
        ZStack {
            Color("backgroundBlue")
                .edgesIgnoringSafeArea(.all)
            
            ActiveView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }
    }
}

struct EmptyState: View {
    @State var opacity: Double = 0.0
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Nothing Active!")
                .modifier(FocalistFont(font: .heading2))
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
            
            Button(action: {
                self.state.currentScene = .store
            }) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color.white)
                    .overlay(Text("Choose Task").modifier(FocalistFont(font: .mediumText)).foregroundColor(Color("backgroundBlue")))
            }.frame(maxWidth: 500, maxHeight: 40).padding()
            Spacer().frame(height: 64)
        }.opacity(self.opacity)
            .onAppear {
                return withAnimation(.easeOut(duration: 0.2)) {
                    self.opacity = 1.0
                }
        }
    }
}
