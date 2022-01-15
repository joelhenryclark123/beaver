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
            .move(edge: .trailing)
    }
    
    static var storeTransition: AnyTransition {
        AnyTransition
            .move(edge: .leading)
    }
}
