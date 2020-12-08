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
    var activeFetchedResultsController: NSFetchedResultsController<ToDo>!
    var storeFetchedResultsController: NSFetchedResultsController<ToDo>!
    
    // MARK: - Initialization
    init(moc: NSManagedObjectContext) {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: "onboarded")
        #endif
        
        // Load To Dos / Context
        self.context = moc
        
        super.init()
        
        self.refresh(newFetch: true)
    }
    
    private func setupFetchController() {
        self.activeFetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.todayListFetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.activeFetchedResultsController.delegate = self
        
        self.storeFetchedResultsController = NSFetchedResultsController<ToDo>.init(
            fetchRequest: ToDo.storeFetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.storeFetchedResultsController.delegate = self
    }
    
    private func setupLists() {
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
    }
    
    // MARK: - Functions
    public func refresh(newFetch: Bool = false) {
        if newFetch {
            self.setupFetchController()
        }
        self.setupLists()
        self.focusedToDo = self.activeList.first(where: { $0.focusing })
        self.updateScene()
    }
    
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
            toDo.moveToStore(stayActive: true)
        }
        
        setupLists()
    }
    
    func completeDay() -> Void {
        if !activeList.contains(where: { $0.isComplete }) {
            let toDo = ToDo(context: context, title: "Finish Day")
            toDo.movedAt = Date()
            toDo.completedAt = Date()
            try? context.save()
        }
        activeList.forEach { (toDo) in
            if toDo.isComplete {
                toDo.totallyFinish()
            } else {
                toDo.moveToStore(stayActive: false)
            }
        }
        #if DEBUG
        #else
        Analytics.logEvent("completedDay", parameters: nil)
        #endif
    }
    
    func startDay() {
        if !activeList.isEmpty || storeList.contains(where: { $0.isActive }) {
            for toDo in storeList { if toDo.isActive { toDo.moveToDay() } }
            for toDo in activeList { toDo.moveToDay() }
            try? context.save()
            
            #if DEBUG
            #else
            Analytics.logEvent("startedDay", parameters: nil)
            #endif
        }
    }
    
    func deleteFromStore(index: Int) {
        storeList.remove(at: index).delete()
    }
    
    func unfocus() {
        if self.focusedToDo != nil {
            self.focusedToDo?.toggleFocus()
        }
    }
    
    private func updateScene() -> Void {
        if self.hasOnboarded == false { self.scene = .onboarding }
        else if self.activeList.allSatisfy({ $0.movedAt != nil }) && self.activeList.count >= 1 {
            if self.activeList.allSatisfy({ $0.isArchived }) { self.scene = .end }
            else if self.focusedToDo != nil { self.scene = .focusing }
            else { self.scene = .middle }
        }
        else { self.scene = .beginning }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.refresh()
        }
    }
}
