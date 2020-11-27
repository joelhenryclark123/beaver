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
    // MARK: - Published Properties
    @Published var hasOnboarded: Bool = UserDefaults.standard.bool(forKey: "onboarded")
    @Published var storeList: [ToDo] = []
    @Published var activeList: [ToDo] = []
    @Published var scene: Scene = .beginning
    @Published var focusedToDo: ToDo?
    
    // MARK: - Other Properties
    var context: NSManagedObjectContext
    var activeFetchedResultsController: NSFetchedResultsController<ToDo>
    var storeFetchedResultsController: NSFetchedResultsController<ToDo>
    
    // MARK: - Initialization
    init(moc: NSManagedObjectContext) {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        // Load To Dos / Context
        self.context = moc
        
        self.activeFetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.todayListFetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.storeFetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.storeFetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
                
        self.activeFetchedResultsController.delegate = self
        
        setupList()
    }
    
    private func setupList() {
        // Active List
        do {
            try self.activeFetchedResultsController.performFetch()
            self.activeList = self.activeFetchedResultsController.fetchedObjects ?? []
            self.focusedToDo = self.activeList.first(where: { $0.focusing })
        } catch { fatalError() }
        
        // Store List
        do {
            try self.storeFetchedResultsController.performFetch()
            self.storeList = self.storeFetchedResultsController.fetchedObjects ?? []
        } catch { fatalError() }
        
        updateScene()
    }
        
    // MARK: - Functions
    func createToDo(title: String, active: Bool) -> Void {
        let toDo = ToDo(
            context: self.context,
            title: title,
            isActive: active
        )
        
        active ? activeList.append(toDo) : storeList.append(toDo)
                
        #if DEBUG
        #else
        Analytics.logEvent("createdToDo", parameters: nil)
        #endif
    }
    
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
        if activeList.allSatisfy({ $0.isComplete }) {
            activeList.forEach({ $0.totallyFinish() })
        }
        
        #if DEBUG
        #else
        Analytics.logEvent("completedDay", parameters: nil)
        #endif
    }
    
    func startDay() {
        for toDo in storeList { if toDo.isActive { toDo.moveToDay() } }
        try? context.save()
        
        #if DEBUG
        #else
        Analytics.logEvent("startedDay", parameters: nil)
        #endif
    }
    
    func deleteFromStore(index: Int) {
        storeList.remove(at: index).delete()
    }
    
    private func updateScene() -> Void {
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

// MARK: - NSFetchedResultsControllerDelegate
extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let active = controller.fetchedObjects as? [ToDo] else { return }
        self.focusedToDo = active.first(where: { $0.focusing })
        self.activeList = active
        updateScene()
    }
}
