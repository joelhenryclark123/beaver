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
                self.toDo.makeActive()
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
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        mc.reset()
        
        return mc
    }()
    

    
    static var previews: some View {
        StoreItem(
            toDo: ToDo(
                context: context,
                title: "Walk 500 miles",
                isActive: false)
            )
            .environmentObject(AppState())
            .previewLayout(.sizeThatFits)
    }
}
