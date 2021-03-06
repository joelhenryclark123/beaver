//
//  NudgeButton.swift
//  Beaver
//
//  Created by Joel Clark on 11/24/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct NudgeButton: View {
    @EnvironmentObject var state: AppState
    @Binding var nudging: Bool
    @State var icon: Icon
    
    var action: () -> Void
    let dimensions = CGSize(width: 48, height: 48)
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(nudging ? Color("accentWhite") : Color(state.scene.color.rawValue + "Dark"))
                .modifier(FocalistShadow(option: .heavy))
                .overlay(Circle().stroke(
                            nudging ? Color("accentWhite") : Color(state.scene.color.rawValue + "Light"),
                            lineWidth: 2
                ))
            
            icon.image
                .frame(maxHeight: 14, alignment: .center)
                .foregroundColor(nudging ? icon.highlightColor : Color("accentWhite"))
                .modifier(FocalistShadow(option: .light))
        }
        .modifier(BouncePress(draggable: false, action: action))
        .frame(width: dimensions.width, height: dimensions.height)
        .transition(.opacity)
        .animation(.easeIn(duration: 0.2))
    }
    
    enum Icon {
        case check
        case next
        case previous
        
        var image: Image {
            switch self {
            case .check:
                return Image(systemName: "checkmark")
            case .next:
                return Image(systemName: "chevron.right")
            case .previous:
                return Image(systemName: "chevron.left")
            }
        }
        
        var highlightColor: Color {
            switch self {
            case .check:
                return Color(FocalistColor.accentGreen.rawValue + "Dark")
            case .next:
                return Color(FocalistColor.backgroundBlue.rawValue + "Dark")
            default:
                return Color("accentWhite")
            }
        }
    }
}

struct NudgeButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .backgroundBlue), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            NudgeButton(nudging: .constant(false), icon: .check) {
                print("hello")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding()
        }
    }
}
