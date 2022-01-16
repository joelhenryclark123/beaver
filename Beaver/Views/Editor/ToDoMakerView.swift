//
//  ToDoMakerView.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct ToDoMakerView: View {
    @Binding var showing: Bool
    @State var destination: Scene = .beginning
    @State var text = ""
    
    var body: some View {
        ZStack {
            background
            
            VStack {
                EditorHeader(
                    destination: $destination,
                    leftAction: { showing = false }
                )
                
                Spacer()
                
                EditableToDoView(text: $text, scene: $destination) { text in
                    submit(text)
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    var background: some View {
        ZStack {
            AnimatedBeavGradient(scene: $destination)
            
            Color.black.opacity(0.3)
        }.edgesIgnoringSafeArea(.all)
    }
    
    func submit(_ text: String) {
        return
    }
}

struct ToDoMakerView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoMakerView(showing: .constant(true))
    }
}
