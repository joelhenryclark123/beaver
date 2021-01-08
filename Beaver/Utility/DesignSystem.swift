//
//  DesignSystem.swift
//  Stack
//
//  Created by Joel Clark on 3/1/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct FocalistFont: ViewModifier {
    enum Typography {
        case heading1, heading2, heading3, heading4
        case largeText, mediumText, caption, smallText, reallySmallText
        case largeTextSemibold, mediumTextSemibold, captionSemibold, smallTextSemibold
        
        var fontSize: CGFloat {
            switch self {
            case .heading1:
                return 56
            case .heading2:
                return 40
            case .heading3:
                return 32
            case .heading4:
                return 24
            case .largeText, .largeTextSemibold:
                return 24
            case .mediumText, .mediumTextSemibold:
                return 20
            case .caption, .captionSemibold:
                return 16
            case .smallText, .smallTextSemibold:
                return 12
            case .reallySmallText:
                return 8
            }
        }
        
        var weight: Font.Weight {
            switch self {
            case .heading1, .heading2, .heading3, .heading4:
                return .bold
            case .largeText, .mediumText, .caption, .smallText, .reallySmallText:
                return .regular
            case .largeTextSemibold, .mediumTextSemibold, .captionSemibold, .smallTextSemibold:
                return .semibold
            }
        }
    }
    
    var font: Typography
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: font.fontSize, weight: font.weight))
    }
}


struct FocalistShadow: ViewModifier {
    enum Shadow {
        case heavy
        case dark
        case light
        
        var color: Color {
            switch self {
            case .heavy:
                return Color("heavyShadow")
            case .dark:
                return Color("darkShadow")
            case .light:
                return Color("lightShadow")
            }
        }
        
        var radius: CGFloat {
            switch self {
            case .heavy:
                return 4
            case .dark:
                return 2
            case .light:
                return 1
            }
        }
        
        var x: CGFloat {
            switch self {
            case .heavy, .dark, .light:
                return CGFloat.zero
            }
        }
        
        var y: CGFloat {
            switch self {
            case .heavy:
                return 4
            case .dark:
                return 2
            case .light:
                return 1
            }
        }
    }
    
    var option: Shadow
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: option.color,
                radius: option.radius,
                x: option.x,
                y: option.y
        )
    }
}

struct FocalistMaterial: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Blur(style: .light))
    }
    
    struct Blur: UIViewRepresentable {
        var style: UIBlurEffect.Style = .systemMaterial
        
        func makeUIView(context: Context) -> UIVisualEffectView {
            return UIVisualEffectView(effect: UIBlurEffect(style: style))
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }
}

enum FocalistColor: String {
    case backgroundBlue = "backgroundBlue"
    case otherBlue = "otherBlue"
    case accentGreen = "accentGreen"
    case accentPink = "accentPink"
    case accentOrange = "accentOrange"
    case accentYellow = "accentYellow"
}

func buildGradient(color: FocalistColor) -> Gradient {
    Gradient(colors: [
        Color(color.rawValue + "Light"),
        Color(color.rawValue + "Dark")
    ])
}

// MARK: Gestures w/ animation
struct BouncePress: ViewModifier {
    @GestureState var state: (pressing: Bool, offset: CGSize) = (false, CGSize.zero)
    
    var draggable: Bool = true
    var action: () -> Void
        
    func body(content: Content) -> some View {
        content
            .offset(draggable ? state.offset : CGSize.zero)
            .scaleEffect(state.pressing ? 0.7 : 1.0)
            .animation(.interactiveSpring())
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).updating($state, body: { (value, state, tx) in
                state.offset = CGSize(width: value.translation.width / 4, height: value.translation.height / 4)
                state.pressing = true
            }).onEnded({ (value) in
                if value.translation.width <= 32 && value.translation.height <= 32,
                   value.translation.width >= -32 && value.translation.height >= -32 {
                    action()
                }
            }))
    }
}

struct BouncePressWithHold: ViewModifier {
    @State var pressing: Bool = false
    var handleTap: () -> Void
    var handleLongPress: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(self.pressing ? 0.8 : 1.0)
            .onTapGesture {
                self.handleTap()
            }
            .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 20) { (press) in
                self.pressing = press
            } perform: {
                handleLongPress()
            }
    }

}

// MARK: Shake Animation
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
