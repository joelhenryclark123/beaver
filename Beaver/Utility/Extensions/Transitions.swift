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
            .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity))
    }
    
    static var storeTransition: AnyTransition {
        AnyTransition
            .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )

    }
}
