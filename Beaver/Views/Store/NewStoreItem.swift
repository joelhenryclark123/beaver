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
                toDo.delete()
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }))
    }

    var background: some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundColor(toDo.isActive ? Color("accentWhite") :  Color("unselectedBlack"))
            .aspectRatio(1.0, contentMode: .fit)        
    }
}

struct NewStoreItem_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("accentPinkDark")
            NewStoreItem(toDo: ToDo(context: ContentView_Previews.demoContext, title: "Hello!"))
                .frame(width: 143, height: 143)
        }
    }
}
