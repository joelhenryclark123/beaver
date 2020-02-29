//
//  StoreView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StoreView: View {
    @EnvironmentObject var state: AppState
    @FetchRequest(
        fetchRequest: ToDo.storeFetchRequest
    ) var toDos: FetchedResults<ToDo>
    
    // MARK: Body
    var body: some View {
        VStack {
        AddBar()
            .gesture(TapGesture().onEnded({ (_) in
                self.state.currentScene = .store
            }))
            
            List{
                ForEach(toDos) { toDo in
                    StoreItem(toDo: toDo)
                }.onDelete { (offsets) in
                    for index in offsets {
                        self.toDos[index].delete()
                    }
                }
            }
            
            Spacer().frame(height: 60)
        }
        .modifier(StoreStyle())
        .gesture(DragGesture(minimumDistance: 30).onChanged({ (value) in
            self.state.dragState = .draggingStore(translation: value.translation)
        }).onEnded({ (value) in
            switch self.state.currentScene {
            case .store:
                if value.predictedEndTranslation.height >= 100 {
                    self.state.currentScene = .active
                }
            case .active:
                if value.predictedEndTranslation.height <= -50 {
                    self.state.currentScene = .store
                }
                case .draggingActive:
                    break
            }
            
            self.state.dragState = .inactive
        }))
            .animation(.easeInOut)
    }
}

struct StoreView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let state: AppState = {
        let returner = AppState()
        returner.currentScene = .store
        return returner
    }()
    
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StoreView()
                .environment(\.managedObjectContext, context)
                .environmentObject(state)
        }
    }
}

// MARK: Style
struct StoreStyle: ViewModifier {
    @EnvironmentObject var state: AppState
    
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 39.5,
                    style: .continuous)
            )
            .shadow(radius: 16, y: -8)
            .padding(state.currentScene == .store ? 0 : 16)
            .edgesIgnoringSafeArea(.bottom)
        .offset(y: state.dragState.storeTranslation.height + state.currentScene.storeOffset)
        .opacity(state.currentScene == .active ? 0.5 : 1.0)
    }
}
