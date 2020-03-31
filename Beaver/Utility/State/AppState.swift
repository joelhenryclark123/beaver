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

final class AppState: NSObject, ObservableObject {
    var fetchedResultsController: NSFetchedResultsController<ToDo>
    
    @Published var hasOnboarded: Bool
    @Published var activeList: [ToDo]
    @Published var scene: Scene
    
    init(moc: NSManagedObjectContext) {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        let hasOnboarded = UserDefaults.standard.bool(forKey: "onboarded")
        self.hasOnboarded = hasOnboarded
        
        self.activeList = []
        
        self.fetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.todayListFetch,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.scene = .beginning
        super.init()
                
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.activeList = self.fetchedResultsController.fetchedObjects ?? []
        } catch { fatalError() }
        updateScene()
    }
    
    func finishOnboarding() {
        self.hasOnboarded = true
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
    
    enum Scene {
        case beginning
        case middle
        case end
        
        var color: FocalistColor {
            switch self {
            case .beginning:
                return .accentPink
            case .middle:
                return .backgroundBlue
            case .end:
                return .accentGreen
            }
        }
    }
    
    func updateScene() -> Void {
        if self.activeList.count == 4 {
            if self.activeList.allSatisfy({ $0.isArchived }) { self.scene = .end }
            else { self.scene = .middle }
        }
        else { self.scene = .beginning }
    }
}

extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let active = controller.fetchedObjects as? [ToDo] else { return }
        self.activeList = active
        updateScene()
    }
}
