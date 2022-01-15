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
            
            // White Background
            RoundedRectangle(cornerRadius: 23.0)
                .foregroundColor(Color("accentWhite"))
                .frame(width: 141, height: 45, alignment: .center)
            
            // Title
            Text(title)
                .modifier(FocalistFont(font: .mediumText))
                .foregroundColor(Color(destination.color.rawValue + "Dark"))
        }
        .frame(width: 144, height: 48, alignment: .center)
        .modifier(BouncePress(action: {
            change()
        }))
    }
    
    func change() {
        if destination == .beginning {
            destination = .middle
        } else {
            destination = .beginning
        }
    }
}

struct DestinationSwitcher_Previews: PreviewProvider {
    static let scene = Scene.middle
    
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
        }
    }
}
