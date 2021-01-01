//
//  CanvasAssignments+CoreDataProperties.swift
//  
//
//  Created by Joel Clark on 12/28/20.
//
//

import Foundation
import CoreData


extension CanvasAssignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CanvasAssignment> {
        return NSFetchRequest<CanvasAssignment>(entityName: "CanvasAssignment")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var index: Int16
    @NSManaged public var course: CanvasCourse?
}
