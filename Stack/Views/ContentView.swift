//
//  ContentView.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct MainBackground: View {
    var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [
                Color("backgroundBlueDark"),
                Color("backgroundBlueLight"),
                ]), startPoint: .bottom, endPoint: .top
            ).edgesIgnoringSafeArea(.all)
        }
}

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.managedObjectContext) var context
    
    //MARK: Body
    var body: some View {
        ZStack {
            MainBackground().zIndex(0)
            
            ActiveView().zIndex(1)
            
            StoreView().zIndex(2)
            
            if self.state.hasOnboarded == false {
                Onboarding()
                    .transition(.move(edge: .bottom))
                    .zIndex(3)
            }
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
