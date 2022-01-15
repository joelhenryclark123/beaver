//
//  DestinationSwitcher.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct DestinationSwitcher: View {
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
            RoundedRectangle(cornerRadius: 23.0)
                .fill(
                    LinearGradient(
                        gradient: buildGradient(color: destination.color),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .id(title.hashValue)

            
            // White Background
            RoundedRectangle(cornerRadius: 23.0)
                .foregroundColor(Color("accentWhite"))
                .frame(width: 141, height: 45, alignment: .center)
            
            // Title
            Text(title)
                .id(title.hashValue)
                .modifier(FocalistFont(font: .mediumText))
                .foregroundColor(Color(destination.color.rawValue + "Dark"))
        }
        .frame(width: 144, height: 48, alignment: .center)
        .modifier(BouncePress(draggable: false, action: {
            change()
        }))
        .transaction { transaction in
            transaction.animation = .easeInOut(duration: 1.0)
        }
        .transition(.opacity)
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
