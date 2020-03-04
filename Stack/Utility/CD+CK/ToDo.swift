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
    
    convenience init(
        context: NSManagedObjectContext,
        title: String,
        isActive: Bool
    ) {
        self.init(context: context)
        self.title = title
        self.completedAt = nil
        self.createdAt = Date()
        self.isActive = isActive
        saveContext()
    }
    
    func saveContext() {
        do {
            if self.managedObjectContext!.hasChanges {
                try self.managedObjectContext?.save()
            }
        } catch {
            fatalError()
        }
    }
}

//MARK: Operations
extension ToDo {
    func activate() {
        guard let context = self.managedObjectContext else { fatalError() }
        
        context.perform {
            self.isActive = true
            self.saveContext()
        }
    }
    
    func store() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            self.isActive = false
            self.saveContext()
        }
    }
    
    func completeToggle() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            if self.isActive {
                if self.completedAt == nil {
                    self.completedAt = Date()
                } else {
                    self.completedAt = nil
                }
                
            } else {
                fatalError()
            }
            
            self.saveContext()
        }
    }
    
    var isComplete: Bool {
        if self.completedAt != nil {
            return true
        } else { return false }
    }
    
    func delete() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            context.delete(self)
            self.saveContext()
        }
    }
    
    // MARK: Fetch Requests
    static var activeFetchRequest: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "(isActive == true)"
        )
        fetchRequest.sortDescriptors = []
        
        
        return fetchRequest
    }
    
    static var storeFetchRequest: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "(completedAt == nil) AND (isActive == false)"
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        
        return fetchRequest
    }
}
