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
    @ObservedObject var toDo: ToDo
    let cornerRadius: CGFloat = 18
    
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .foregroundColor(
                toDo.isActive ? Color("accentWhite") : Color("lightShadow")
            )
            .onTapGesture(perform: {
                self.toDo.activeToggle()
            })
    }
    
    var body: some View {
        Text(toDo.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier(FocalistFont(font: .mediumText))
            .foregroundColor(toDo.isActive ? Color("blackText") : Color("accentWhite"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(cardBackground)
            .transition(.opacity)
            .animation(.easeIn(duration: 0.2), value: toDo.isActive)
    }
}

// MARK: - Previews
struct StoreItem_Previews: PreviewProvider {
    static let context = ContentView_Previews.demoContext
    
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .accentPink), startPoint: .top, endPoint: .bottom)
        StoreItem(
            toDo: ToDo(
                context: context,
                title: "Walk 100 miles",
                isActive: false)
        )
            .previewLayout(.sizeThatFits)
        }
    }
}
