//
//  Preview Helper.swift
//  Beaver
//
//  Created by Joel Clark on 5/7/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class PreviewHelper {
    static let moc: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
                let toDos = try! mc.fetch(ToDo.fetchRequest())
                for toDo in toDos {
                    (toDo as! ToDo).delete()
                }
        
//                let list: [ToDo] = [
//                    ToDo(
//                        context: mc,
//                        title: "Walk 100 miles",
//                        isActive: true
//                    ),
//                    ToDo(
//                        context: mc,
//                        title: "Walk 200 miles",
//                        isActive: true
//                    ),
//                    ToDo(
//                        context: mc,
//                        title: "Walk 300 miles",
//                        isActive: true
//                    ),
//                    ToDo(
//                        context: mc,
//                        title: "Walk 400 miles",
//                        isActive: true
//                    ),
//                ]
        
        return mc
    }()
    
    static let demoAddBar: some View = {
        AddBar().environmentObject(AppState(moc: PreviewHelper.moc))
    }()
}

