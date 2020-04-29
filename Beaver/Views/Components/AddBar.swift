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
    @State var version: Version = .unselected
    @State var text: String = ""
    @State var color: FocalistColor = .backgroundBlue
    
    let height: CGFloat = 48
    let cornerRadius: CGFloat = 24
    let horizontalPadding: CGFloat = 16
    let verticalPadding: CGFloat = 10
    
    enum Version {
        case unselected
        case selected
        
        mutating func toggle() {
            switch self {
            case .unselected:
                self = .selected
            case .selected:
                self = .unselected
            }
        }
    }
    
    func createToDo() -> Void {
        let _ = ToDo(
            context: self.context,
            title: self.text,
            isActive: false
        )
        
        self.text = ""
        
        #if DEBUG
        #else
        Analytics.logEvent("createdToDo", parameters: nil)
        #endif
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(height: height)
                .foregroundColor(
                    (version == Version.unselected) ? Color("dimWhite") : Color("accentWhite")
            )
                .blendMode(.colorDodge)
                .modifier(FocalistShadow(option: self.version == .selected ? .heavy : .dark))
                .zIndex(0)
            
            HStack {
                TextField("", text: $text, onEditingChanged: { _ in self.version.toggle() }) {
                    if self.text.isEmpty { return }
                    else { self.createToDo() }
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .modifier(FocalistFont(font: .largeTextSemibold))
                .accentColor(Color(color.rawValue))
                .zIndex(3)
                .padding(.leading, horizontalPadding)
                
                if self.version == .selected {
                    attachmentsButton
                        .transition(.opacity)
                        .animation(.linear)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    var attachmentsButton: some View {
        let size: CGFloat = 28
        
        return Image(systemName: "paperclip.circle")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(Color("accentOrangeLight"))
            .padding(.trailing, horizontalPadding)
            .padding(.vertical, verticalPadding)
    }
}

struct AddBar_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var previews: some View {
        ZStack {
            MainBackground()
                .environmentObject(AppState(moc: context))
            
            AddBar()
                .environment(\.managedObjectContext, context)
        }
    }
}
