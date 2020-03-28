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
        case largeText, mediumText, caption, smallText
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
            }
        }
        
        var weight: Font.Weight {
            switch self {
            case .heading1, .heading2, .heading3, .heading4:
                return .bold
            case .largeText, .mediumText, .caption, .smallText:
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
                return 12
            case .dark:
                return 8
            case .light:
                return 4
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
            case .heavy, .dark:
                return 4
            case .light:
                return 2
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
