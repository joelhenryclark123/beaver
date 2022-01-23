//
//  DestinationSwitcher.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct DestinationSwitcher: View {
    @EnvironmentObject var state: AppState
    @Binding var destination: Scene
    
    var title: String {
        if destination == .beginning {
            return "Later"
        } else {
            return "Today"
        }
    }
    
    var body: some View {
        ZStack {
            // Border
            AnimatedBeavGradient(scene: $destination)
                .clipShape(RoundedRectangle(cornerRadius: 23.0))

            
            // White Background
            RoundedRectangle(cornerRadius: 23.0)
                .foregroundColor(Color("accentWhite"))
                .frame(width: 141, height: 45, alignment: .center)
            
            // Title
            Text(title)
                .id(title.hashValue)
                .modifier(FocalistFont(font: .mediumText))
                .foregroundColor(Color(destination.color.rawValue + "Dark"))
                .transaction { transaction in
                    transaction.animation = .easeInOut(duration: 0.3)
                }
                .transition(.opacity)
        }
        .frame(width: 144, height: 48, alignment: .center)
        .modifier(FocalistShadow(option: .button, color: destination.color.shadowColor))
        .modifier(BouncePress(draggable: false, action: {
            if state.scene != .end {
                change()
            }
        }))
        
    }
    
    func change() {
        withAnimation {
            if destination == .beginning {
                destination = .middle
            } else {
                destination = .beginning
            }
        }
    }
}

struct DestinationSwitcher_Previews: PreviewProvider {
    static var scene = Scene.beginning
    
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: buildGradient(color: scene.color),
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            
            DestinationSwitcher(destination: .constant(scene))
//            DestinationSwitcher()
        }
    }
}
