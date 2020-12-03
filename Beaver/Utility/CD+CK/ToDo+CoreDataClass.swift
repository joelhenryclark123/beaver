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
    convenience init(
        context: NSManagedObjectContext,
        title: String,
        isActive: Bool = false,
        inboxDate: Date? = nil
    ) {
        self.init(context: context)
        
        let currentDate = Date()
        
        self.title = title
        self.completedAt = nil
        self.createdAt = currentDate
        self.isActive = isActive
        self.movedAt = nil
        self.focusing = false
        
        // Set inbox date
        if inboxDate == nil {
            self.inboxDate = currentDate
        } else {
            self.inboxDate = (inboxDate! < currentDate) ? currentDate : inboxDate!.convertToMMddyyyy()
        }
        
        saveContext()
    }
    
    func saveContext() {
        try? self.managedObjectContext?.save()
    }
    
    // MARK: Calculated Properties
    var onTodaysList: Bool {
        let calendar = Calendar.current
        guard let movedAt = self.movedAt else { return false }
        
        return calendar.isDateInToday(movedAt)
    }
    
    var isComplete: Bool {
        self.completedAt != nil
    }
    
    var isArchived: Bool {
        self.isComplete && (self.isActive == false)
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
    
    func moveToStore(stayActive: Bool = false) {
        guard let context = self.managedObjectContext else { fatalError() }
        
        context.perform {
            self.isActive = stayActive
            self.movedAt = nil
            self.focusing = false
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
                
                self.focusing = false
            } else {
                fatalError()
            }
            
            self.saveContext()
        }
    }
    
    func toggleFocus() {
        if self.focusing {
            self.unfocus()
        } else { self.focus() }
    }
    
    func focus() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            if let toDos = try? ToDo.focusFetch.execute() {
                toDos.forEach({ $0.unfocus() })
            }
            self.focusing = true
            self.saveContext()
        }
    }
    
    func unfocus() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            self.focusing = false
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
            self.saveContext()
        }
    }
    
    func totallyFinish() {
        guard let context = self.managedObjectContext else { fatalError() }
        context.perform {
            if (self.completedAt == nil) { self.completedAt = Date() }
            self.isActive = false
            self.focusing = false
            self.saveContext()
        }
    }
    
    // MARK:- Fetch Requests
    static var todayListFetch: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest<ToDo>(entityName: entity)
        
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.startOfDay(for: Date()) as NSDate
        
        fetchRequest.predicate = NSPredicate(
            format: "(movedAt > %@) || (completedAt > %@)", beginningOfDay, beginningOfDay
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]

        return fetchRequest
    }
    
    static var storeFetch: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: entity)
        
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let beginningOfTomorrow = calendar.startOfDay(for: tomorrow)
                
        fetchRequest.predicate = NSPredicate(
            format: "(completedAt == nil) && (inboxDate < %@)", beginningOfTomorrow as NSDate
        )
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "inboxDate", ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        
        return fetchRequest
    }
    
    static var focusFetch: NSFetchRequest<ToDo> {
        let entity: String = String(describing: ToDo.self)
        let fetchRequest: NSFetchRequest<ToDo> = NSFetchRequest<ToDo>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(
            format: "focusing == true"
        )
        
        return fetchRequest
    }
}

extension Date {
    func convertToMMddyyyy() -> Date {
        let calendar = Calendar.current
        let beginningOfDay = calendar.startOfDay(for: self)
        return beginningOfDay
    }
}
