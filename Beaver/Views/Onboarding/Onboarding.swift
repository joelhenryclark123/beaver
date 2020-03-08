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
        VStack(spacing: 16) {
            
            VStack {
            Text("Beaver")
                .modifier(FocalistFont(font: .heading1))
            Text("A new way to get things done")
                .modifier(FocalistFont(font: .mediumText))
            }
            
            Spacer()

            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Text("Store")
                        .modifier(FocalistFont(font: .heading4))
                    Text("tasks in your to-do list")
                        .modifier(FocalistFont(font: .largeText))
                }
                HStack(spacing: 8) {
                    Text("Choose")
                        .modifier(FocalistFont(font: .heading4))
                    Text("what you want to do")
                        .modifier(FocalistFont(font: .largeText))
                }
            }
            
            Spacer()
            
            WideButton(.blue, "Get Started") {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.state.finishOnboarding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            Color.white.edgesIgnoringSafeArea(.all)
        )
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
