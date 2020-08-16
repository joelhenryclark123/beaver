//
//  ToDo+CoreDataProperties.swift
//  
//
//  Created by Joel Clark on 8/16/20.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var completedAt: Date?
    @NSManaged public var createdAt: Date
    @NSManaged public var focusing: Bool
    @NSManaged public var isActive: Bool
    @NSManaged public var movedAt: Date?
    @NSManaged public var title: String

}
