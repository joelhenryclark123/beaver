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
    var namespace: Namespace.ID
    let list: [ToDo]
    
    let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
        
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text(todayWeekDay)
                    .font(.largeTitle).bold()
                    .foregroundColor(Color("accentWhite"))
                    .multilineTextAlignment(.center)

                Text(todayDate)
                    .foregroundColor(Color("dimWhite"))
                    .multilineTextAlignment(.center)
            }.padding(.vertical, 16)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(list, id: \.self) { toDo in
                    CardView(toDo: toDo)
                        .matchedGeometryEffect(id: toDo.geometryId.uuidString, in: namespace)
                        .opacity(toDo.focusing ? 0.0 : 1.0)
                        .zIndex(toDo == self.state.lastFocused ? .infinity : 1)
                }
            }.padding()
            
            Spacer().frame(height: 72).listRowBackground(EmptyView())
        }
    }
    
    init(namespace: Namespace.ID, list: [ToDo]) {
        self.list = list
        self.namespace = namespace
    }
    
    var todayWeekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        return weekDay
    }
    
    var todayDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
}
