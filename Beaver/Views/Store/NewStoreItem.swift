//
//  NewStoreItem.swift
//  Beaver
//
//  Created by Joel Clark on 12/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct NewStoreItem: View {
    @ObservedObject var toDo: ToDo
    @State var editingToDo: Bool = false
    var body: some View {
        ZStack {
            background
            
            Text(toDo.title)
                .modifier(FocalistFont(font: .mediumText))
                .multilineTextAlignment(.center)
                .foregroundColor(toDo.isActive ? .black : Color("accentWhite"))
                .padding(8)
            
        }.modifier(BouncePressWithHold(handleTap: {
            self.toDo.activeToggle()
        }, handleLongPress: {
            return
        }))
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                editingToDo = true
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }
            
            Button(action: {
                toDo.delete()
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }))
        .fullScreenCover(isPresented: $editingToDo, content: {
            EditorView(toDo: toDo, showing: $editingToDo)
        })
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundColor(toDo.isActive ? Color("accentWhite") :  Color("unselectedBlack"))
            .aspectRatio(1.0, contentMode: .fit)
            .modifier(FocalistShadow(option: .dark, color: toDo.isActive ? FocalistColor.accentPink.shadowColor : Color.clear))
    }
}
