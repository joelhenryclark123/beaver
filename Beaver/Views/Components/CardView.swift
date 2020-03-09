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
                    .foregroundColor(toDo.isComplete ? Color("accentGreenDim") : Color.white)
                    .modifier(FocalistShadow(option: .dark))
                
                if !self.toDo.isComplete {
                Text(self.toDo.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
                    .modifier(FocalistFont(font: .mediumText))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(8)
                    .zIndex(3)
                } else {
                    Image(systemName: "checkmark")
                        .resizable()
                        .padding(32)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .transition(.scale)
                        .zIndex(4)
                }
                
                #if DEBUG
                Text(String(toDo.isComplete)).frame(maxHeight: .infinity, alignment: .bottom)
                #endif
            }.onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.toDo.completeToggle()
                }
            }.aspectRatio(1.0, contentMode: .fit)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static let context = ActiveView_Previews.context
//    
//    static var previews: some View {
//        ZStack {
//            MainBackground()
//        DayView()
//        .environment(\.managedObjectContext, context)
//        .environmentObject(AppState())
//        }
//    }
//}
