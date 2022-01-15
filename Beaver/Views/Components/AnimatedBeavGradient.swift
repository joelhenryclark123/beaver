//
//  AnimatedBeavGradient.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct AnimatedBeavGradient: View {
    @Binding var scene: Scene
    var body: some View {
        ZStack {
            pinkBackground
                .opacity(scene == .beginning ? 1.0 : 0.0)
            
            blueBackground
                .opacity(scene == .middle ? 1.0 : 0.0)
            
            greenBackground
                .opacity(scene == .end ? 1.0 : 0.0)
            
        }
        .transaction { transaction in
            transaction.animation = .easeInOut(duration: 0.3)
        }
        .transition(.opacity)
    }
    
    var pinkBackground: some View {
        LinearGradient(
            gradient: buildGradient(color: FocalistColor.accentPink),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var blueBackground: some View {
        LinearGradient(
            gradient: buildGradient(color: FocalistColor.backgroundBlue),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var greenBackground: some View {
        LinearGradient(
            gradient: buildGradient(color: FocalistColor.accentGreen),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct AnimatedBeavGradient_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBeavGradient(scene: .constant(.middle))
    }
}
