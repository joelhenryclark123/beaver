//
//  CanvasCourse+CoreDataProperties.swift
//  
//
//  Created by Joel Clark on 12/28/20.
//
//

import Foundation
import CoreData


extension CanvasCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CanvasCourse> {
        return NSFetchRequest<CanvasCourse>(entityName: "CanvasCourse")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var assignments: NSSet?

}

// MARK: Generated accessors for assignments
extension CanvasCourse {

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: CanvasAssignment)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: CanvasAssignment)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSSet)

}
