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
    
    func moveAssignment(_ source: IndexSet, _ destination: Int) {
        var assignments = getAssignmentsArray()
//        guard let startIndex = source.first else { fatalError("No index set in CanvasCourse.moveAssignment(source: destination:)")}
        
        guard let context = managedObjectContext else { fatalError() }
        context.perform {
            assignments.move(fromOffsets: source, toOffset: destination)
            
            for i in assignments.indices {
                assignments[i].index = Int16(i)
            }
        
            self.saveContext()
        }
    }
    
    func getAssignmentsArray() -> [CanvasAssignment] {
        guard let assignments = self.assignments,
              let assignmentsArray = Array(assignments as Set) as? [CanvasAssignment]
        else { return [] }
        
        return assignmentsArray.sorted(by: { $0.index < $1.index })
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
