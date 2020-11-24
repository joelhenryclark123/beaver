//
//  AddButton.swift
//  Beaver
//
//  Created by Joel Clark on 11/24/20.
//  Copyright © 2020 MyCo. All rights reserved.
//
//  https://www.figma.com/file/NweNXgafILih1q6qN65z30/Components?node-id=84%3A84
//

import SwiftUI

struct AddButton: View {
    @State var color: Color
    var action: () -> Void
    let dimensions = CGSize(width: 64, height: 64)
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background Circle
                Circle()
                    .foregroundColor(Color("dimWhite"))
                
                // Plus Button
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(color)
                    .modifier(FocalistShadow(option: .dark))
                
                // Inner Shadow
                Circle()
                    .stroke(Color.clear, lineWidth: 4)
                    .foregroundColor(.clear)
                    .modifier(FocalistShadow(option: .dark))
                    .clipShape(Circle())
                
            }
        }
        .frame(width: dimensions.width, height: dimensions.height)
        
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .backgroundBlue), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            AddButton(color: Color(FocalistColor.backgroundBlue.rawValue)) {
                print("hello!")
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding()
        }
    }
}
