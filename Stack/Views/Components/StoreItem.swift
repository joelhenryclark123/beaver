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
        Button(action: {
            self.toDo.activate()
            self.state.currentScene = .active
        }) {
                Text(toDo.title)
                    .modifier(FocalistFont(font: .mediumText))
                    .foregroundColor(.black)
                
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.white))
        }.modifier(FocalistShadow(option: .dark))
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