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
    @GestureState var pressing: Bool = false
    static let cornerRadius: CGFloat = 48
    
    var background: some View {
        Group {
            if toDo.isComplete {
                Color("otherBlue")
                .overlay(
                    RoundedRectangle(cornerRadius: CardView.cornerRadius)
                        .stroke(Color("otherBlue").opacity(0.0), lineWidth: 4)
                        .modifier(FocalistShadow(option: .light))
                )
            }
            else {
                Color("accentWhite")
                    .modifier(FocalistShadow(option: .light))
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: CardView.cornerRadius, style: .circular)
        )
    }
    
    var body: some View {
        ZStack {
            background
            
//            #if DEBUG
//            VStack{
//                Spacer()
//                Text("focused: \(String(self.toDo.focusing))")
//            }
//            #endif
            
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
                    .foregroundColor(Color("dimWhite"))
                    .transition(.scale)
                    .zIndex(4)
            }
        }
        .scaleEffect(self.pressing ? 0.9 : 1.0)
        .animation(.easeIn(duration: 0.2))
        .gesture(hold)
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    var hold: some Gesture {
        // Get some haptics going
        let generator = UINotificationFeedbackGenerator()
        
        return SimultaneousGesture(
            LongPressGesture(minimumDuration: 1.0, maximumDistance: 15)
                .updating($pressing, body: { (bool, state, tx) in
                    state = bool
                }).onEnded({ (value) in
                    self.toDo.toggleFocus()
                }),
            TapGesture()
                .onEnded({
                    self.toDo.completeToggle()
                    if self.toDo.isComplete {
                        generator.notificationOccurred(.success)
                    }
                })
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static let toDo = ToDo(context: PreviewHelper.moc, title: "Sup", isActive: true)
    
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: buildGradient(color: .otherBlue),
                startPoint: .top,
                endPoint: .bottom
            )
                .edgesIgnoringSafeArea(.all)
            
            PreviewHelper.demoAddBar
            
            CardView(toDo: toDo)
            .padding()
        }
    }
}
