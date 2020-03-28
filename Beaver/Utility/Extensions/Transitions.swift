//
//  Transitions.swift
//  Beaver
//
//  Created by Joel Clark on 3/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var dayTransition: AnyTransition {
        AnyTransition
            .scale(scale: 25.0)
            .combined(with: .opacity)
            .animation(.spring())
    }
    
    static var storeTransition: AnyTransition {
        AnyTransition
            .move(edge: .bottom)
            .animation(.spring())
    }
}
