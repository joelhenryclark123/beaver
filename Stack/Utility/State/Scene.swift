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
    case stack
    case store
    
    var stackOffset: CGFloat {
        CGFloat.zero
    }
    
    var storeOffset: CGFloat {
        let peakingHeight: CGFloat = 76 * 2
        switch self {
        case .store:
            return CGFloat.zero
        case .stack:
            return (UIScreen.main.bounds.height - peakingHeight)
        }
    }
}
