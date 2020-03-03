//
//  WideButton.swift
//  Stack
//
//  Created by Joel Clark on 3/3/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct WideButton: View {
    enum Version {
        case white
        case blue
        
        var backgroundColor: Color {
            switch self {
            case .white:
                return Color.white
            case .blue:
                return Color("backgroundBlue")
            }
        }
        
        var fontColor: Color {
            switch self {
            case .white:
                return Color("backgroundBlue")
            case .blue:
                return Color.white
            }
        }
        
        var shadowOption: FocalistShadow.Shadow {
            switch self {
            case .white:
                return .dark
            case .blue:
                return .blueGlow
            }
        }
    }
    
    var version: Version
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(version.backgroundColor)
                .frame(maxWidth: 480, maxHeight: 40)
                .modifier(FocalistShadow(option: version.shadowOption))
            .overlay(
                Text(text)
                    .modifier(FocalistFont(font: .mediumText))
                    .foregroundColor(version.fontColor)
            )
        }
    }
    
    init(_ version: Version, _ text: String, action: @escaping () -> Void) {
        self.version = version
        self.text = text
        self.action = action
    }
}

struct WideButton_Previews: PreviewProvider {
    static var previews: some View {
        WideButton(.blue, "Get Started") {
            print("sup")
        }
    }
}
