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
import FirebaseAnalytics

final class AppState: NSObject, ObservableObject {
    // MARK: - All Properties
    @Published var hasOnboarded: Bool
    @Published var activeList: [ToDo]
    @Published var scene: Scene
    @Published var focusedToDo: ToDo?
    
    var context: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<ToDo>
    
    // MARK: - Initialization
    init(moc: NSManagedObjectContext) {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        let hasOnboarded = UserDefaults.standard.bool(forKey: "onboarded")
        self.hasOnboarded = hasOnboarded
        
        self.context = moc
        self.fetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.todayListFetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.activeList = []
        self.scene = .beginning
        
        super.init()
                
        self.fetchedResultsController.delegate = self
        
        setupList()
    }
    
    private func setupList() {
        do {
            try self.fetchedResultsController.performFetch()
            self.activeList = self.fetchedResultsController.fetchedObjects ?? []
            self.focusedToDo = self.activeList.first(where: { $0.focusing })

        } catch { fatalError() }
        
        updateScene()
    }
    
    // MARK: - Functions
    func finishOnboarding() {
        self.hasOnboarded = true
        self.scene = .beginning
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
    
    func editDay() -> Void {
        for toDo in activeList {
            toDo.moveToStore()
        }
        
        updateScene()
    }
    
    func completeDay() -> Void {
        activeList.forEach({ $0.totallyFinish() })
        
        #if DEBUG
        #else
        Analytics.logEvent("completedDay", parameters: nil)
        #endif
    }
    
    // MARK: - Scene Management
    enum Scene {
        case onboarding
        case beginning
        case middle
        case focusing
        case end
        case attaching
        
        var color: FocalistColor {
            switch self {
            case .onboarding:
                return .accentOrange
            case .beginning:
                return .accentPink
            case .middle:
                return .backgroundBlue
            case .focusing:
                return .otherBlue
            case .attaching:
                return .accentOrange
            case .end:
                return .accentGreen
            }
        }
    }
    
    func updateScene() -> Void {
        DispatchQueue.main.async {
            if self.hasOnboarded == false { self.scene = .onboarding }
            else if self.activeList.count >= 1 {
                if self.activeList.allSatisfy({ $0.isArchived }) { self.scene = .end }
                else if self.focusedToDo != nil { self.scene = .focusing }
                else { self.scene = .middle }
            }
            else { self.scene = .beginning }
        }
    }
}

extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let active = controller.fetchedObjects as? [ToDo] else { return }
        self.focusedToDo = active.first(where: { $0.focusing })
        self.activeList = active
        updateScene()
    }
}
