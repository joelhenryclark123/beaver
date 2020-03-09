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
                .transition(.opacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(FocalistFont(font: .mediumText))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(8)
                .zIndex(3)
            }
            
//            if !self.toDo.isComplete {
//                Text(self.toDo.title)
//                    .transition(.opacity)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .modifier(FocalistFont(font: .mediumText))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.black)
//                    .padding(8)
//                    .zIndex(3)
//            }
                
            if self.toDo.isComplete {
                Image(systemName: "checkmark")
                    .resizable()
                    .padding(32)
                    .transition(.scale)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .zIndex(3)
            }
        }.aspectRatio(1.0, contentMode: .fit)
.onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                self.toDo.completeToggle()
            }
        }
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
