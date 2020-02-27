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
        
        if isActive {
            self.movedAt = Date()
        } else {
            self.movedAt = nil
        }
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try self.managedObjectContext?.save()
        } catch {
            fatalError()
        }
    }
}

extension ToDo {
    
    func complete() {
        self.completedAt = Date()
        self.isActive = false
        
        saveContext()
    }
    
    func makeActive() {
        self.isActive = true
        self.movedAt = Date()
        saveContext()
    }
    
    func delete() {
        self.managedObjectContext?.delete(self)
        saveContext()
    }
}
