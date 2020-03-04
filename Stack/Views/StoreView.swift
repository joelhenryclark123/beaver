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
            List {
                ForEach(self.toDos) { toDo in
                    StoreItem(toDo: toDo)
                }.onDelete { (offsets) in
                    for index in offsets {
                        self.toDos[index].delete()
                    }
                }
            }
            Spacer().frame(height: 40)
        }
        .modifier(StoreStyle())
    }
}

struct StoreView_Previews: PreviewProvider {
    static let context = ContentView_Previews.context
    static let state: AppState = {
        let returner = AppState()
        return returner
    }()
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            StoreView()
                .environment(\.managedObjectContext, context)
        }
    }
}

// MARK: Style
struct StoreStyle: ViewModifier {
    @EnvironmentObject var state: AppState
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 500)
            .background(
                RoundedRectangle(
                    cornerRadius: 39.5,
                    style: .continuous).hidden()
                    .modifier(FocalistMaterial())
                    .clipShape(RoundedRectangle(cornerRadius: 39.5,
                                                style: .continuous))
        )
            .edgesIgnoringSafeArea(.bottom)
    }
}
