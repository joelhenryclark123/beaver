//
//  EditableToDoView.swift
//  Beaver
//
//  Created by Joel Clark on 1/16/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct EditableToDoView: View {
    // TODO: Make focusable w/ iOS 15 @FocusState
    
    @Binding var text: String
    @Binding var scene: Scene
    
    //    @State var text: String
    //    @State var scene: Scene
    
    var onSubmit: (_ text: String) -> ()
    
    var body: some View {
        SquareBackgroundView(foregroundColor: Color("accentWhite"), shadowColor: scene.color.shadowColor)
            .overlay(textField)
    }
    
    var textField: some View {
        TextField(
            "New",
            text: $text,
            onCommit: { onSubmit(text) }
        )
        .modifier(FocalistFont(font: .mediumText))
        .multilineTextAlignment(.center)
        .accentColor(scene.color.asColor())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }
    
}

struct EditableToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBeavGradient(scene: .constant(.beginning))
                .edgesIgnoringSafeArea(.all)
            
            EditableToDoView(text: .constant(""), scene: .constant(.beginning), onSubmit: {_ in })
            //            EditableToDoView(text: "", scene: .beginning, onSubmit: {_ in })
            
        }
    }
}
