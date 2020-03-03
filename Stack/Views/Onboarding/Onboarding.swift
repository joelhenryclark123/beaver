//
//  Onboarding.swift
//  Stack
//
//  Created by Joel Clark on 3/3/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct Onboarding: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            Text("Monocle")
                .modifier(FocalistFont(font: .heading1))
            Text("A new way to get things done")
                .modifier(FocalistFont(font: .mediumText))
            
            Spacer()
            
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                        Text("Organize")
                            .modifier(FocalistFont(font: .heading4))
                        Text("Tasks in your to-do list")
                            .modifier(FocalistFont(font: .largeText))
                }
                VStack(spacing: 8) {
                    Text("Choose")
                        .modifier(FocalistFont(font: .heading4))
                    Text("What you want to do")
                        .modifier(FocalistFont(font: .largeText))
                }
            }.frame(maxWidth: 480)
            
            Spacer()
            
            WideButton(.blue, "Get Started") {
                let _ = ToDo(context: self.context, title: "Drag this around!", isActive: true)
                let _ = ToDo(context: self.context, title: "Tap on this to activate it", isActive: false)
                let _ = ToDo(context: self.context, title: "Swipe left to delete this", isActive: false)
                
                withAnimation(.easeIn(duration: 0.2)) {
                    self.state.finishOnboarding()
                }
            }
            }
        .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Onboarding_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = ContentView_Previews.context
        
        return mc
    }()
    
    static var previews: some View {
        Onboarding()
            .environment(\.managedObjectContext, context)
        .environmentObject(AppState())
    }
}
