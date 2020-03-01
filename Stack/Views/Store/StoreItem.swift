//
//  StoreItem.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StoreItem: View {
    @EnvironmentObject var state: AppState
    var toDo: ToDo
    
    var body: some View {
            HStack {
                Button(action: {
                    self.toDo.activate()
                    self.state.currentScene = .active
                }) {
                Image(systemName: "arrowtriangle.up.square")
                .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color("stackBackgroundColor"))
                }
                Text(toDo.title)

                Spacer()
                }.frame(maxWidth: .infinity)
                .padding()
    }
}

struct StoreItem_Previews: PreviewProvider {
    static let state = AppState()
    static let context = ContentView_Previews.context

    static var previews: some View {
        StoreItem(
            toDo: ToDo(
                context: context,
                title: "Walk 100 miles",
                isActive: false)
            )
            .environmentObject(state)
            .previewLayout(.sizeThatFits)
    }
}
