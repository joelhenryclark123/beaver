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
    let cornerRadius: CGFloat = 12
    
    var cardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .foregroundColor(
                    toDo.isActive ? Color("accentWhite") : Color("materialWhite")
                )
                        
            if !(toDo.isActive) {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color("accentWhite"), lineWidth: 2)
            }
        }
        .modifier(FocalistShadow(option: toDo.isActive ? .dark : .light))
        .animation(.easeIn)
    }
    
    var body: some View {
            Text(toDo.title)
                .modifier(FocalistFont(font: .mediumText))
                .foregroundColor(toDo.isActive ? Color("blackText") : Color("accentWhite"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
    }
}

// MARK: - Previews
struct StoreItem_Previews: PreviewProvider {
    static let context = ContentView_Previews.demoContext
    
    static var previews: some View {
        StoreItem(
            toDo: ToDo(
                context: context,
                title: "Walk 100 miles",
                isActive: false)
        )
            .previewLayout(.sizeThatFits)
    }
}
