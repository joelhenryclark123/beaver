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
import Combine

final class AppState: ObservableObject {
    // MARK: Published Properties
    @Published var hasOnboarded: Bool
    
    init() {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        let hasOnboarded = UserDefaults.standard.bool(forKey: "onboarded")
        self.hasOnboarded = hasOnboarded
    }
    
    func finishOnboarding() {
        self.hasOnboarded = true
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
}
