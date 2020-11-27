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
    
    @State var secondsLeft: Int = 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome")
                    .modifier(FocalistFont(font: .heading1))
                
                Text("Add your tasks!")
                    .modifier(FocalistFont(font: .largeText))
                
                if secondsLeft > 0 {
                    Text("\(secondsLeft) seconds")
                        .padding(.top, 16)
                }
                
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .foregroundColor(Color("accentWhite"))
            
            if secondsLeft <= 0 {
                WideButton(.accentYellow, "Get Started") {
                    self.state.finishOnboarding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer, perform: { _ in
            secondsLeft -= 1
        })
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
