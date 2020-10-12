//
//  TaskGrid.swift
//  Beaver
//
//  Created by Joel Clark on 8/21/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct TaskGrid: View {
    @EnvironmentObject var state: AppState
    let list: [ToDo]
    
    let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(list, id: \.self) { toDo in
                    CardView(toDo: toDo)
                }
            }.padding()
        }
    }
    
    init(toDos: FetchedResults<ToDo>) {
        list = toDos.map({ (toDo) -> ToDo in
            toDo
        })
    }
    
    init(list: [ToDo]) {
        self.list = list
    }
}
