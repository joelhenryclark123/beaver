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
        ZStack {
            VStack {
            Text("Beaver")
                .modifier(FocalistFont(font: .heading1))
                Text("Tap the top bar at any time to add an item to your list!")
                .modifier(FocalistFont(font: .largeText))
            }
            .multilineTextAlignment(.center)
            .foregroundColor(Color("accentWhite"))
            .padding(.horizontal)
            
            WideButton(.accentYellow, "Get Started") {
                self.state.finishOnboarding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = ContentView_Previews.demoContext
        
        return mc
    }()
    
    static var previews: some View {
        Onboarding()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState(moc: context))
    }
}
