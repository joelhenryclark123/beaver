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
    static let cornerRadius: CGFloat = 48
    
    var background: some View {
        Group {
            if toDo.isComplete {
                LinearGradient(
                    gradient: buildGradient(color: .accentGreen),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                Color("accentWhite")
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .modifier(FocalistShadow(option: .dark))
        .clipShape(RoundedRectangle(cornerRadius: CardView.cornerRadius, style: .circular))
    }
    
    var body: some View {
        ZStack {
            background
            
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
        }
        .animation(.easeIn(duration: 0.2))
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                self.toDo.completeToggle()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
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
