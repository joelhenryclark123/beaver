//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI


struct CardView: View {
    @State var opacity: Double = 1.0
    @State var topCardPosition = CGSize.zero
    var toDo: ToDo
    var saveBoundary: CGFloat = -200

    
    var body: some View {
        RoundedRectangle(cornerRadius: 38.5, style: .continuous)
            .foregroundColor(Color.white)
            .shadow(radius: 3)
            .overlay (
                Text(toDo.title)
                    .font(.system(size: 34))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
            )
            .offset(x: 0, y: self.topCardPosition.height)
            .gesture(DragGesture().onChanged{ (value) in
                if value.translation.height <= 0 {
                    self.topCardPosition = value.translation
                }
                else {
                    self.topCardPosition.height = value.translation.height / 10
                }
            }.onEnded({ (value) in
                if value.translation.height <= self.saveBoundary {
                    self.topCardPosition.height = -1000
                    self.saveToDo()
                }
                else {
                    self.topCardPosition = CGSize.zero
                }
            }))
            .animation(.easeOut)
    }
    
    func saveToDo() {
        self.toDo.completedAt = Date()
        
        do {
            try self.toDo.managedObjectContext?.save()
        } catch {
            //TODO: Figure this out
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var toDo: ToDo = {
        let returner = ToDo(context: ContentView_Previews.context)
        returner.title = "Grind?"
        returner.createdAt = Date()
        return returner
    }()
    
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            CardView(toDo: toDo)
        }
    }
}
