//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAnalytics


struct DayView: View {
    var toDos: FetchedResults<ToDo>
        
    func completeDay() -> Void {
        self.toDos.forEach({ $0.totallyFinish() })
        Analytics.logEvent("completedDay", parameters: nil)
    }
    
    var body: some View {
        let showingButton: Bool = self.toDos.allSatisfy({ $0.completedAt != nil && $0.isActive == true })
        
        return ZStack {
            if (showingButton) {
                WideButton(.accentOrange, "Complete") {
                        self.completeDay()
                }
                .zIndex(3)
            }
            
            VStack(spacing: 8) {
                #if DEBUG
                Text("showingButton: \(String(showingButton))")
                #endif
                HStack(spacing: 8) {
                    CardView(toDo: self.toDos[0])
                    CardView(toDo: self.toDos[1])
                }
                HStack(spacing: 8) {
                    CardView(toDo: self.toDos[2])
                    CardView(toDo: self.toDos[3])
                }
            }
            .padding()
            .zIndex(2)
        }

//        .transition(.opacity)
//        .animation(.spring())
    }
}


struct DayView_Previews: PreviewProvider {
    
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
