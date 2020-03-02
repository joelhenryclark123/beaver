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
            case .largeText:
                return 24
            case .mediumText:
                return 20
            case .caption:
                return 16
            case .smallText:
                return 12
            }
        }
        
        var bold: Bool {
            switch self {
            case .heading1, .heading2, .heading3, .heading4:
                return true
            default:
                return false
            }
        }
    }
    
    var font: Typography
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: font.fontSize, weight: font.bold ? .bold : .regular))
    }
}


struct FocalistShadow: ViewModifier {
    enum Shadow {
        case dark
        case light
        
        var color: Color {
            switch self {
            case .dark:
                return Color("darkShadow")
            case .light:
                return Color("lightShadow")
            }
        }
        
        var radius: CGFloat {
            switch self {
            case .dark:
                return 8
            case .light:
                return 4
            }
        }
        
        var x: CGFloat {
            switch self {
            case .dark, .light:
                return CGFloat.zero
            }
        }
        
        var y: CGFloat {
            switch self {
            case .dark:
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
