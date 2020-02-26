//
//  DragState.swift
//  Stack
//
//  Created by Joel Clark on 2/26/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import SwiftUI

enum DragState {
    case inactive
    case draggingSideways(translation: CGSize)
    case checkingOff(translation: CGSize)
    
    var scrollTranslation: CGSize {
        switch self {
        case .inactive, .checkingOff(_):
            return .zero
        case .draggingSideways(let translation):
            return translation
        }
    }
    
    var checkingTranslation: CGSize {
        switch self {
        case .inactive, .draggingSideways(_):
            return .zero
        case .checkingOff(let translation):
            return translation
        }
    }
}
