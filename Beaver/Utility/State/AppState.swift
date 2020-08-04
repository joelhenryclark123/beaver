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
    let context: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<ToDo>
    
    @Published var hasOnboarded: Bool
    @Published var attaching: Bool = false
    @Published var activeList: [ToDo]
    @Published var scene: Scene
    @Published var focusedToDo: ToDo?
    
    init(moc: NSManagedObjectContext) {
//        #if DEBUG
//        UserDefaults.standard.set(false, forKey: "onboarded")
//        #endif
        
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
        self.context = moc
        
        super.init()
                
        self.fetchedResultsController.delegate = self
        
        setupList()
    }
    
    func finishOnboarding() {
        self.hasOnboarded = true
        self.scene = .beginning
        UserDefaults.standard.set(true, forKey: "onboarded")
    }
    
    func setupList() {
        do {
            try self.fetchedResultsController.performFetch()
            self.activeList = self.fetchedResultsController.fetchedObjects ?? []
            self.focusedToDo = self.activeList.first(where: { $0.focusing })

        } catch { fatalError() }
        
        updateScene()
    }
    
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
            if self.attaching { self.scene = .attaching }
            else if self.hasOnboarded == false { self.scene = .onboarding }
            else if self.activeList.count >= 1 {
                if self.activeList.allSatisfy({ $0.isArchived }) { self.scene = .end }
                else if self.focusedToDo != nil { self.scene = .focusing }
                else { self.scene = .middle }
            }
            else { self.scene = .beginning }
        }
    }
    
    func toggleAttaching() -> Void {
        self.attaching.toggle()
        updateScene()
    }
    
    func editDay() -> Void {
        for toDo in activeList {
            toDo.moveToStore()
        }
        
        updateScene()
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

// MARK: - Previews
struct AppState_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView_Previews.previews
        }
    }
}
