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
    @Published var activeToDo: ToDo?
    @Published var storedToDos: [ToDo]
    
    // MARK: Core Data stack
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
    
    init() {
        self.activeToDo = nil
        self.storedToDos = []
        
        // Populate active and storage
        let toDos = try! (persistentContainer.viewContext.fetch(
            NSFetchRequest<NSFetchRequestResult>.init(entityName: "ToDo")
        )) as! [ToDo]
        for toDo in toDos {
            if toDo.completedAt == nil {
                if toDo.isActive {
                    self.activate(toDo)
                }
                else {
                    toDo.isActive = false
                    self.storedToDos.append(toDo)
                }
            }
        }
    }
    
    func activate(_ toDo: ToDo) {
        if let og = activeToDo {
            og.movedAt = nil
            og.isActive = false
            storedToDos.insert(og, at: 0)
        }
        
        if !toDo.isActive {
            self.storedToDos.remove(at: self.storedToDos.firstIndex(of: toDo)!)
            toDo.isActive = true
        }
        
        toDo.movedAt = Date()
        activeToDo = toDo

        toDo.saveContext()
    }
    
    func store(_ toDo: ToDo) {
        self.storedToDos.append(toDo)
    }
    
    func completeActive() {
        print("hellllloo1")
        self.activeToDo?.complete()
        self.activeToDo = nil
        print("hello??")
    }
    
    func deleteFromStore(_ index: Int) {
        let toDo = storedToDos.remove(at: index)
        toDo.delete()
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
        
        saveContext()
    }
}
