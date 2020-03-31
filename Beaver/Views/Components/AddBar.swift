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
                .blendMode(.luminosity)
                .modifier(FocalistShadow(option: .dark))
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color(color.rawValue), lineWidth: 4)
                .frame(height: height)
                .zIndex(1.5)
            
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
                .accentColor(Color(color.rawValue))
            .zIndex(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
