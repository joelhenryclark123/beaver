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
    
    var cardBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.white)
            
            if toDo.isActive {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color("accentGreenDim"), lineWidth: 4)
            }
        }.modifier(FocalistShadow(option: .dark))
    }
    
    var body: some View {
            Text(toDo.title)
                .modifier(FocalistFont(font: .mediumText))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
    }
}

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
