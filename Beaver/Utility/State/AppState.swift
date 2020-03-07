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
    @Published var upToDate: Bool!
    
    init() {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        let hasOnboarded = UserDefaults.standard.bool(forKey: "onboarded")
        self.hasOnboarded = hasOnboarded
        
        self.refresh()
    }
    
    func finishOnboarding() {
        self.hasOnboarded = true
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
    
    func refresh() {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let recent = try? mc.fetch(ToDo.fetchMostRecent)
        
        guard let toDos = recent else { fatalError() }
        
        self.upToDate = toDos.allSatisfy({ (toDo) -> Bool in
                if toDo.movedToday { return true }
                else {
                    toDos.forEach({ $0.store() })
                    return false
                }
        })
    }
}
