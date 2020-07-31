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
        
        #if DEBUG
        #else
        Analytics.logEvent("completedDay", parameters: nil)
        #endif
    }
    
    var body: some View {
        let showingButton: Bool = self.state.activeList.allSatisfy({
            $0.completedAt != nil && $0.isActive == true
        })
        
        return ZStack {
            if (showingButton) {
                WideButton(.accentGreen, "Complete") {
                        self.completeDay()
                }
                .zIndex(1)
            }
            
            if self.state.focusedToDo != nil {
                CardView(toDo: self.state.focusedToDo!)
                    .padding()
                    .zIndex(0)
            }
            else {
                taskGrid
                    .padding()
                    .zIndex(0)
            }
            
            VStack {
                Spacer()
                Text("Tap to complete\nLong press for focus")
                    .foregroundColor(Color("dimWhite"))
                    .modifier(FocalistFont(font: .smallTextSemibold))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var taskGrid: some View {
        let columns: [GridItem] = [
            .init(.flexible()),
            .init(.flexible())
        ]
        
        return ScrollView{
            VStack {
                Spacer().frame(height: 60)
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(self.state.activeList, id: \.self) { toDo in
                        CardView(toDo: toDo)
                    }
                }
                
                Spacer().frame(height: 60)
            }}
    }
}


struct DayView_Previews: PreviewProvider {
    
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
