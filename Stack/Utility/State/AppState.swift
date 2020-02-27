//
//  AppState.swift
//  Stack
//
//  Created by Joel Clark on 2/23/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

final class AppState: ObservableObject {
    @Published var dragState: DragState = .inactive
    @Published var currentScene: Scene = .stack
}
