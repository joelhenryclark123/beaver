//
//  CanvasAssignments+CoreDataClass.swift
//  
//
//  Created by Joel Clark on 12/28/20.
//
//

import Foundation
import CoreData

@objc(CanvasAssignment)
public class CanvasAssignment: ToDo {
    convenience init(
        context: NSManagedObjectContext,
        id: String,
        title: String,
        dueDate: Date?
    ) {
        self.init(context: context)
        
        let currentDate = Date()
        self.title = title
        self.completedAt = nil
        self.createdAt = currentDate
        self.isActive = false
        self.movedAt = nil
        self.focusing = false
        self.id = id
        self.dueDate = dueDate
        
        // Set inbox date
        if inboxDate == nil {
            self.inboxDate = currentDate
        } else {
            self.inboxDate = (inboxDate! < currentDate) ? currentDate : inboxDate!.convertToMMddyyyy()
        }
        
        saveContext()
    }
    
    static func makeFetch(for id: String) -> NSFetchRequest<CanvasAssignment> {
        let entity: String = String(describing: CanvasAssignment.self)
        let fetchRequest = NSFetchRequest<CanvasAssignment>(entityName: entity)
                
        fetchRequest.predicate = NSPredicate(
            format: "(id == %@)", id
        )
        
        return fetchRequest
    }
    
    static func storeFetch() -> NSFetchRequest<CanvasAssignment> {
        let entity: String = String(describing: CanvasAssignment.self)
        let fetchRequest = NSFetchRequest<CanvasAssignment>(entityName: entity)
                
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
}
