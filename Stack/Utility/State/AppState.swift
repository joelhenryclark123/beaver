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
    @Published var dragState: DragState = .inactive
    @Published var currentScene: Scene = .stack
    @Published var activeToDo: ToDo? = nil
    @Published var storedToDos: [ToDo] = [ToDo]()
    
    // MARK: Initialization
    init() {
        // Populate active
        do {
            let active = try persistentContainer.viewContext.fetch(activeFetchRequest) 
            self.activeToDo = active.first
            if active.count > 1 {
                for index in (1 ..< active.count) {
                    self.store(active[index])
                }
            }
        } catch {
            fatalError("Failed to fetch active ToDo in AppState init(), error: \(error)")
        }
        
        // Populate Store
        do {
            self.storedToDos = try persistentContainer.viewContext.fetch(storeFetchRequest) 
        } catch {
            fatalError("Failed to fetch active ToDo in AppState init(), error: \(error)")
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        print("loading persistent container...")
        
        let container = NSPersistentCloudKitContainer(name: "Stack")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("error in persistent container initialization!")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("No errors loading persistent container!")
        })
        
        do {
            print("setting query generation...")
            try container.viewContext.setQueryGenerationFrom(.current)
            container.viewContext.automaticallyMergesChangesFromParent = true
            print("query generation set!")
        } catch {
            print("Error setting query generation in app delegate")
        }
        
        
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("App State saveContext() error")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Fetch Requests
    var activeFetchRequest: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "(completedAt == nil) AND (isActive == true)"
        )
        
        return fetchRequest
    }
    
    var storeFetchRequest: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "(completedAt == nil) AND (isActive == false)"
        )
        
        return fetchRequest
    }
}

//MARK: - ToDo operations
extension AppState {
    func activate(_ toDo: ToDo) {
        persistentContainer.viewContext.perform {
            if let og = self.activeToDo {
                og.movedAt = nil
                og.isActive = false
                self.storedToDos.insert(og, at: 0)
            }
            
            if !toDo.isActive {
                self.storedToDos.remove(at: self.storedToDos.firstIndex(of: toDo)!)
                toDo.isActive = true
            }
            
            toDo.movedAt = Date()
            self.activeToDo = toDo
            
            self.saveContext()
        }
    }
    
    func store(_ toDo: ToDo) {
        persistentContainer.viewContext.perform {
            if toDo.isActive {
                self.activeToDo = nil
                toDo.isActive = false
                toDo.movedAt = nil
            }
            
            self.storedToDos.append(toDo)
            self.saveContext()
        }
    }
    
    func completeActive() {
        persistentContainer.viewContext.perform {
            self.activeToDo?.completedAt = Date()
            self.activeToDo = nil
            self.saveContext()
        }
    }
    
    func deleteFromStore(_ index: Int) {
        persistentContainer.viewContext.perform {
            let toDo = self.storedToDos.remove(at: index)
            self.persistentContainer.viewContext.delete(toDo)
            self.saveContext()
        }
    }
}

// MARK: ToDo initializer
extension ToDo {
    convenience init(
        state: AppState,
        title: String,
        isActive: Bool
    ) {
        self.init(context: state.persistentContainer.viewContext)
        
        self.title = title
        self.completedAt = nil
        self.createdAt = Date()
        self.isActive = isActive
        
        if isActive {
            self.movedAt = Date()
            state.activate(self)
        } else {
            self.movedAt = nil
            state.store(self)
        }
        
        state.saveContext()
    }
}
