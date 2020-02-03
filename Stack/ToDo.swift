//
//  ToDo.swift
//  Stack
//
//  Created by Joel Clark on 12/30/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import Foundation

struct ToDo: Identifiable, Hashable, Codable {
    let id = UUID()
    var title: String
    var completedAt: Date? = nil
}

class ToDoStore: ObservableObject {
    @Published var toDos: [ToDo]
    
    var topToDo: ToDo? {
        if toDos.isEmpty {
            return nil
        } else {
            return toDos[0]
        }
    }
    
    func updateDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        if let data = try? PropertyListEncoder().encode(self.toDos) {
            defaults.set(data, forKey: ToDoStore.defaultsKey)
        }
    }
    
    static let defaultsKey = "ToDos"
    
    /*
     Load From Store
     */
    init() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: ToDoStore.defaultsKey) {
            do {
            self.toDos = try PropertyListDecoder().decode([ToDo].self, from: data)
            } catch {
                self.toDos = []
            }
        } else {
            self.toDos = []
        }
    }
    
    /*
     Remove top ToDo
     Update Store
     */
    func checkTopToDo() -> Void {
        toDos.removeFirst()
        
        updateDefaults()
    }
    
    func newToDo(_ todo: ToDo) {
        toDos.append(todo)
        
        updateDefaults()
    }
    
}
