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
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        fetchRequest: ToDo.storeFetchRequest
    ) var toDos: FetchedResults<ToDo>
    
    @State var newToDoTitle: String = ""
    let footerHeight: CGFloat = 60
    
    var body: some View {
        VStack {
            TextField("New", text: $newToDoTitle, onCommit: {
                if self.newToDoTitle.isEmpty {
                    return
                } else {
                    let _ = ToDo(
                        context: self.context,
                        title: self.newToDoTitle,
                        isActive: false
                    )
                    
                    self.newToDoTitle = ""
                }
            })
                .padding(.leading, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .frame(height: 32)
                        .foregroundColor(Color.gray)
                        .opacity(0.3)
            ).gesture(TapGesture().onEnded({ (_) in
                self.state.currentScene = .store
            }))
                .padding(.horizontal, 16)
                .padding(.top, 24)
            
            List{
                ForEach(toDos) { toDo in
                    StoreItem(toDo: toDo)
                }.onDelete { (offsets) in
                    for index in offsets {
                        self.toDos[index].delete()
                    }
                }
            }
            
            Spacer().frame(height: footerHeight)
        }
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 39.5,
                style: .continuous)
        )
        .padding(state.currentScene == .store ? 0 : 16)
        .shadow(radius: 16, y: -8)
    }
}

struct StoreView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StoreView()
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }
    }
}
