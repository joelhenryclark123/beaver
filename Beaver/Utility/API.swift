//
//  API.swift
//  Beaver
//
//  Created by Joel Clark on 10/19/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import CoreData

struct APItoDo: Codable {
    var title: String
    var inboxDate: String
    
    static let dateFormatter: DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    func convertToCD(context: NSManagedObjectContext) -> Void {
        let toDo = ToDo(context: context,
                     title: self.title,
                     inboxDate: APItoDo.dateFormatter.date(from: self.inboxDate)
        )
        
        print("DATECHECK: \(toDo.inboxDate)")
    }
}

class API {
    func getToDo(url: URL, completion: @escaping ([APItoDo]) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard err == nil else { fatalError(err?.localizedDescription ?? "error in API Call for todo") }
            
            guard let toDos = try? JSONDecoder().decode([APItoDo].self, from: data!) else {
                print(String(data: data!, encoding: String.Encoding.utf8))
                return
            }
            
            DispatchQueue.main.async {
                completion(toDos)
            }
        }.resume()
    }
}
