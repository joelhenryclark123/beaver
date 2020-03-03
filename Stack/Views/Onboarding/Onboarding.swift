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
            Spacer()
            Text("Monocle")
                .modifier(FocalistFont(font: .heading1))
            Text("A new way to get things done")
                .modifier(FocalistFont(font: .mediumText))
            
            Spacer()
            
            WideButton(.blue, "Get Started") {
                withAnimation(.easeIn(duration: 0.2)) {
                    let _ = ToDo(context: self.context, title: "Drag this around!", isActive: true)
                    let _ = ToDo(context: self.context, title: "Tap on this to activate it", isActive: false)
                    let _ = ToDo(context: self.context, title: "Swipe left to delete this", isActive: false)
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
