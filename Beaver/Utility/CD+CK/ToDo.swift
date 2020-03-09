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
    
    // MARK: Calculated Properties
    var onTodaysList: Bool {
        let calendar = Calendar.current
        guard let movedAt = self.movedAt else { return false }
        
        return calendar.isDateInToday(movedAt)
    }
    
    var isComplete: Bool {
        if self.completedAt != nil {
            return true
        } else { return false }
    }
}

//MARK: Operations
extension ToDo {
    func activeToggle() {
        guard let context = self.managedObjectContext else { fatalError() }
        
        context.perform {
            self.isActive.toggle()
            self.saveContext()
        }
    }
    
    func moveToStore() {
        guard let context = self.managedObjectContext else { fatalError() }
        
        context.perform {
            self.isActive = false
            self.movedAt = nil
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
        
    func delete() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            context.delete(self)
            self.saveContext()
        }
    }
    
    func moveToDay() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            self.movedAt = Date()
            self.isActive = true
        }
    }
    
    func totallyFinish() {
        guard let context = self.managedObjectContext else { fatalError() }
        assert(self.completedAt != nil && self.isActive && self.movedAt != nil)
        context.perform {
            self.isActive = false
        }
    }
    
    // MARK: Fetch Requests
    static var todayListFetch: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest<ToDo>(entityName: entity)
        
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.startOfDay(for: Date())
        
        fetchRequest.predicate = NSPredicate(
            format: "(movedAt >= %@)", beginningOfDay as NSDate
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        fetchRequest.fetchBatchSize = 4

        return fetchRequest
    }
    
    static var storeFetch: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "(completedAt == nil) AND (movedAt == nil)"
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        
        return fetchRequest
    }
}
