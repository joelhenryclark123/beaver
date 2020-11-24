//
//  Footer.swift
//  Beaver
//
//  Created by Joel Clark on 11/24/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct Footer: View {
    @EnvironmentObject var state: AppState
    @State var nudge: Bool
    
    var body: some View {
        HStack {
            // Left Item
            if state.scene == .middle {
                NudgeButton(nudging: false, icon: .previous, action: { })
            } else {
                NudgeButton(nudging: false, icon: .previous, action: { }).hidden()
            }
            
            Spacer()
            
            AddButton(color: Color(state.scene.color.rawValue), action: { })
            
            Spacer()
            
            // Right Item
            switch state.scene {
            case .beginning:
                NudgeButton(nudging: nudge, icon: .next, action: { })
            case .middle:
                NudgeButton(nudging: nudge, icon: .check, action: { })
            default:
                NudgeButton(nudging: nudge, icon: .previous, action: { }).hidden()
            }
        }
    }
    
}

struct Footer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .accentPink), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Footer(nudge: false)
                    .environmentObject(AppState(moc: ContentView_Previews.demoContext))
                    .padding()
            }
        }
    }
}
