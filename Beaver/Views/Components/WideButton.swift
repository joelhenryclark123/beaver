//
//  WideButton.swift
//  Stack
//
//  Created by Joel Clark on 3/3/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct WideButton: View {
    static let cornerRadius: CGFloat = 12
    var color: FocalistColor
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .modifier(FocalistFont(font: .largeTextSemibold))
                .foregroundColor(Color("accentWhite"))
                .frame(maxWidth: 480)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
                .background(Color(color.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: WideButton.cornerRadius, style: .circular))
                .modifier(FocalistShadow(option: .dark))
                .overlay(
                    RoundedRectangle(cornerRadius: WideButton.cornerRadius, style: .circular)
                        .stroke(LinearGradient(
                            gradient: buildGradient(color: color),
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 4)
            )
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
        .animation(.spring())
    }
    
    init(_ version: FocalistColor, _ text: String, action: @escaping () -> Void) {
        self.color = version
        self.text = text
        self.action = action
    }
}

struct WideButton_Previews: PreviewProvider {
    static var previews: some View {
        WideButton(.accentOrange, "Start Day") {
            print("sup")
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}
