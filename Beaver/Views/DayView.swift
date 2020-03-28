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
    
    var dayComplete: Bool {
        self.toDos.allSatisfy(
            {$0.completedAt != nil && $0.isActive == false}
        )
    }
    
    var emptyState: some View {
        VStack {
            Text("Done!")
                .modifier(FocalistFont(font: .heading1))
                .foregroundColor(.white)
            Text("Come back tomorrow")
                .modifier(FocalistFont(font: .mediumTextSemibold))
                .foregroundColor(.white)
            Text("(or save a task for later with the add bar)")
                .modifier(FocalistFont(font: .smallText))
                .foregroundColor(Color("dimWhite"))
        }
    }
        
    var body: some View {
        let showingButton: Bool = self.toDos.allSatisfy({ $0.completedAt != nil && $0.isActive == true })

        return ZStack {
            if (showingButton) {
                WideButton(.white, "Complete") {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.completeDay()
                    }
                }.padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                .zIndex(3)
            }
            Group {
            if dayComplete {
                emptyState.zIndex(1)
            } else {
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
            }.transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
