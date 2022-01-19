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
    
    @FocusState private var isFocused: Bool
    
    //    @State var text: String
    //    @State var scene: Scene
    
    var onSubmit: (_ text: String) -> ()
    
    var body: some View {
        SquareBackgroundView(foregroundColor: Color("accentWhite"), shadowColor: scene.color.shadowColor)
            .overlay(textField)
            .onTapGesture {
                isFocused = true
            }
    }
    
    var textField: some View {
        TextField(
            "",
            text: $text,
            onCommit: { onSubmit(text) }
        )
        .modifier(FocalistFont(font: .mediumText))
        .multilineTextAlignment(.center)
        .accentColor(scene.color.asColor())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .focused($isFocused)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
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
