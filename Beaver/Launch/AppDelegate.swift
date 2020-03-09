//
//  AppDelegate.swift
//  Stack
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectionStyle = .none
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        print("loading persistent container...")
        
        // Load Stores
        let container = NSPersistentCloudKitContainer(name: "Stack")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("error in persistent container initialization!")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("No errors loading persistent container!")
        })
        
        // Set query gen
        do {
            print("setting query generation...")
            try container.viewContext.setQueryGenerationFrom(.current)
            container.viewContext.automaticallyMergesChangesFromParent = true
            
            if container.viewContext.hasChanges {
                try! container.viewContext.save()
            }
            
            print("query generation set!")
        } catch {
            print("Error setting query generation in app delegate")
        }
        
        // Deactivate old to dos
        let storeToDos = try! container.viewContext.fetch(ToDo.storeFetch)
        let calendar = Calendar.current
        storeToDos.forEach { (toDo) in
            if (!toDo.onTodaysList) { toDo.moveToStore() }
        }
        
//        #if DEBUG
//        let toDos = try! container.viewContext.fetch(ToDo.fetchRequest())
//        for toDo in toDos {
//            container.viewContext.delete(toDo as! NSManagedObject)
//        }
////        let _ = ToDo(context: container.viewContext, title: "sup", isActive: true).moveToDay()
////        let _ = ToDo(context: container.viewContext, title: "sup", isActive: true).moveToDay()
////        let _ = ToDo(context: container.viewContext, title: "sup", isActive: true).moveToDay()
////        let _ = ToDo(context: container.viewContext, title: "sup", isActive: true).moveToDay()
////        let _ = ToDo(context: container.viewContext, title: "sup", isActive: true).moveToDay()
//
//
//        try! container.viewContext.save()
//
//        #endif
                
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("App delegate savecontext error")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

