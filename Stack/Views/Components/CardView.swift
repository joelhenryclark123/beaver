//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var toDo: ToDo
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .aspectRatio(1.0, contentMode: .fit)
                .foregroundColor(toDo.completedAt == nil ?
                    Color.white : Color("accentGreenDim")
            )
                .modifier(FocalistShadow(option: .dark))
            
            
            Group {
                if self.toDo.completedAt == nil {
                    Text(self.toDo.title)
                        .transition(.opacity)
                        .frame(maxWidth: .infinity)
                        .modifier(FocalistFont(font: .mediumText))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(8)
                    .zIndex(3)
                }
                else {
                    Image(systemName: "checkmark")
                    .resizable()
                    .padding(32)
                        .transition(.scale)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .zIndex(3)
                }
                }
        }.animation(.easeInOut(duration: 0.2))
        .onTapGesture {
            
            withAnimation(.easeIn(duration: 0.2)) {
            self.toDo.completeToggle()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let context = ActiveView_Previews.context
    
    static var previews: some View {
        ZStack {
            MainBackground()
        ActiveView()
        .environment(\.managedObjectContext, context)
        .environmentObject(AppState())
        }
    }
}
