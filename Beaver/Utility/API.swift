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
