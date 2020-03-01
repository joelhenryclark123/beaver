//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    
    //MARK: Body
    var body: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ActiveView()
            
            StoreView()
                .zIndex(1)
        }
    }
}

//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let toDos = try! mc.fetch(ToDo.fetchRequest())
        for toDo in toDos {
            (toDo as! ToDo).delete()
        }
        
        return mc
    }()

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
