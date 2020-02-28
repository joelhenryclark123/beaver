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
        self.movedAt = isActive ? Date() : nil
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
            if let ogActive = try? context.fetch(ToDo.activeFetchRequest).first {
                ogActive.store()
            }
            self.isActive = true
            self.movedAt = Date()
            self.saveContext()
        }
    }
    
    func store() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            self.isActive = false
            self.movedAt = nil
            self.saveContext()
        }
    }
    
    func complete() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            if self.isActive {
                self.isActive = false
                self.completedAt = Date()
            } else {
                fatalError()
            }
            
            self.saveContext()
        }
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
            format: "(completedAt == nil) AND (isActive == true)"
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
