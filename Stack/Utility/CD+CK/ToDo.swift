//
//  ToDo.swift
//  Stack
//
//  Created by Joel Clark on 12/30/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import Foundation
import CoreData

public class ToDo: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var completedAt: Date?
    @NSManaged var createdAt: Date?
    @NSManaged var isActive: Bool
    @NSManaged var movedAt: Date?
    
    weak var state: AppState
    
    // MARK: - Initialization
    convenience init(
        state: AppState,
        title: String,
        isActive: Bool
    ) {
        self.init(context: state.persistentContainer.viewContext)
        
        self.state = state
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

//MARK: Operations
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
