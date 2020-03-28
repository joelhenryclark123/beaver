//
//  AddBar.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics

struct AddBar: View {
    @Environment(\.managedObjectContext) var context
    @State var showingPlaceholder: Bool = true
    @State var text: String = ""
    var upToDate: Bool
    var color: FocalistColor = .backgroundBlue
    let height: CGFloat = 48
    let cornerRadius: CGFloat = 24
    
    func createToDo() -> Void {
        let _ = ToDo(
            context: self.context,
            title: self.text,
            isActive: false
        )
        
        self.text = ""
        
        Analytics.logEvent("createdToDo", parameters: nil)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(height: height)
                .foregroundColor(Color("dimWhite"))
                .modifier(FocalistShadow(option: .heavy))
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color(color.rawValue), lineWidth: 4)
                .frame(height: height)
                .zIndex(1.5)
            
            if showingPlaceholder {
                Text(upToDate ? "Do Later" : "Add a To Do")
                    .foregroundColor(.gray)
                    .zIndex(2)
            }
            
            TextField(
                "",
                text: $text,
                onEditingChanged: { _ in self.showingPlaceholder.toggle() },
                onCommit: {
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
            .zIndex(3)
        }
    }
}

struct AddBar_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var previews: some View {
        ZStack {
            MainBackground()
            
            AddBar(upToDate: false)
                .environment(\.managedObjectContext, context)
        }
    }
}
