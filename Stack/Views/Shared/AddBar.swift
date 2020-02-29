//
//  AddBar.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct AddBar: View {
    @Environment(\.managedObjectContext) var context
    @State var text: String = ""
    var willBeActive: Bool = false
        
    func createToDo() -> Void {
        let _ = ToDo(
            context: self.context,
            title: self.text,
            isActive: self.willBeActive
        )
        
        self.text = ""
    }
    
    var body: some View {
        TextField("New", text: $text, onCommit: {
            if self.text.isEmpty {
                return
            } else { self.createToDo() }
        })
            .padding(.leading, 10)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .frame(height: 32)
                    .foregroundColor(Color.gray)
                    .opacity(0.2)
        ).padding(.horizontal, 16)
        .padding(.top, 24)
    }
}

struct AddBar_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var previews: some View {
        AddBar()
        .environment(\.managedObjectContext, context)
    }
}
