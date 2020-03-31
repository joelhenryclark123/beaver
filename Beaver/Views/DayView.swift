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
    @EnvironmentObject var state: AppState
    func completeDay() -> Void {
        self.state.activeList.forEach({ $0.totallyFinish() })
        Analytics.logEvent("completedDay", parameters: nil)
    }
    
    var body: some View {
        let showingButton: Bool = self.state.activeList.allSatisfy({ $0.completedAt != nil && $0.isActive == true })
        
        return ZStack {
            if (showingButton) {
                WideButton(.accentGreen, "Complete") {
                        self.completeDay()
                }
                .zIndex(1)
            }
            
            VStack(spacing: 8) {
//                #if DEBUG
//                Text("showingButton: \(String(showingButton))")
//                #endif
                HStack(spacing: 8) {
                    CardView(toDo: self.state.activeList[0])
                    CardView(toDo: self.state.activeList[1])
                }
                HStack(spacing: 8) {
                    CardView(toDo: self.state.activeList[2])
                    CardView(toDo: self.state.activeList[3])
                }
            }
            .padding()
            .zIndex(0)
        }
    }
}


struct DayView_Previews: PreviewProvider {
    
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
