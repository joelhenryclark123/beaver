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
            Button(action:  {
                self.state.currentScene = .stack
                self.toDo.activate()
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("stackBackgroundColor"))
            }
            Text(toDo.title)

            Spacer()
            }.frame(maxWidth: .infinity).padding()
    }
}

struct StoreItem_Previews: PreviewProvider {
    static let state = AppState()
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
