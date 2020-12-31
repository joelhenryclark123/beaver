//
//  CanvasCourse+CoreDataClass.swift
//  
//
//  Created by Joel Clark on 12/28/20.
//
//

import Foundation
import CoreData

@objc(CanvasCourse)
public class CanvasCourse: NSManagedObject {
    convenience init(
        context: NSManagedObjectContext,
        id: String,
        name: String,
        startDate: Date,
        endDate: Date
    ) {
        self.init(context: context)
        
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        
        saveContext()
    }
    
    func saveContext() {
        try? self.managedObjectContext?.save()
    }
    
    static func makeFetch(for id: String) -> NSFetchRequest<CanvasCourse> {
        let entity: String = String(describing: CanvasCourse.self)
        let fetchRequest = NSFetchRequest<CanvasCourse>(entityName: entity)
                
        fetchRequest.predicate = NSPredicate(
            format: "(id == %@)", id
        )
        
        return fetchRequest
    }
    
    static func activeClasses(_ date: Date = Date()) -> NSFetchRequest<CanvasCourse> {
        let entity: String = String(describing: CanvasCourse.self)
        let fetchRequest = NSFetchRequest<CanvasCourse>(entityName: entity)
        
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: date) as NSDate
        let tenYearsLater = calendar.date(byAdding: .year, value: 10, to: date)! as NSDate
        
        fetchRequest.predicate = NSPredicate(
            format: "(startDate < %@) && (endDate > %@)", today, tenYearsLater
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchRequest
    }
}
