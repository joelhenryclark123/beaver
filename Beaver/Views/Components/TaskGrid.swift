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
    
    var todayWeekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        return weekDay
    }
    
    var todayDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
}
