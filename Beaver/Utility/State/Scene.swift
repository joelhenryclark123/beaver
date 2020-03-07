//
//  Scene.swift
//  Stack
//
//  Created by Joel Clark on 2/26/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import SwiftUI

enum Scene {
    case active
    case draggingActive
    case store
    
    var storeOffset: CGFloat {
        let peakingHeight: CGFloat = 76 * 2 + 24
        switch self {
        case .store:
            return CGFloat.zero
        case .active:
            return (UIScreen.main.bounds.height - peakingHeight)
        case .draggingActive:
            return UIScreen.main.bounds.height
        }
    }
}
