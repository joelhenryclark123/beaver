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
    
    func delete() {
        self.managedObjectContext?.delete(self)
        saveContext()
    }
}
