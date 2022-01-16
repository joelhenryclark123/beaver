//
//  SquareBackgroundView.swift
//  Beaver
//
//  Created by Joel Clark on 1/16/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct SquareBackgroundView: View {
    @State var sunken: Bool = false
    @State var foregroundColor: Color
    @State var shadowColor: Color
    
    var body: some View {
        Group {
            if !sunken {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .foregroundColor(foregroundColor)
                    .modifier(FocalistShadow(option: .dark, color: shadowColor))
            } else {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .foregroundColor(foregroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .stroke(foregroundColor.opacity(0.0), lineWidth: 4)
                            .modifier(FocalistShadow(option: .light, color: shadowColor))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct SquareBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBeavGradient(scene: .constant(.beginning))
                .edgesIgnoringSafeArea(.all)
            
            SquareBackgroundView(
                sunken: false,
                foregroundColor: Color("accentWhite"),
                shadowColor: Color("accentPinkShadow")
            )
        }
    }
}
