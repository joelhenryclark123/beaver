//
//  GeometryProxy.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    var center: CGPoint {
        CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    }
}
