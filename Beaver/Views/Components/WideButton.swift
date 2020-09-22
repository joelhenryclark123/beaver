//
//  WideButton.swift
//  Stack
//
//  Created by Joel Clark on 3/3/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct WideButton: View {
    static let cornerRadius: CGFloat = 24
    var color: FocalistColor
    var text: String
    var action: () -> Void
    
    var body: some View {
        var textColor: Color {
            switch color {
            case .accentYellow:
                return Color("blackText")
            default:
                return Color("accentWhite")
            }
        }
        
        return Button(action: action) {
            Text(text)
                .modifier(FocalistFont(font: .largeTextSemibold))
                .foregroundColor(textColor)
                .frame(maxWidth: 480)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
                .background(Color(color.rawValue))
                .clipShape(RoundedRectangle(cornerRadius: WideButton.cornerRadius, style: .circular))
                .modifier(FocalistShadow(option: .heavy))
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal, 32)
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
