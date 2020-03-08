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
            } else {
                withAnimation(.spring()) {
                self.createToDo()
                }
            }
        })
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(height: 40)
                    .foregroundColor(Color("dimWhite"))
                    .modifier(FocalistShadow(option: .dark))
        )
    }
}

struct AddBar_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            AddBar()
                .environment(\.managedObjectContext, context)
        }
    }
}