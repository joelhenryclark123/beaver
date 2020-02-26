//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI


struct CardView: View {
    var toDo: ToDo

    var body: some View {
        VStack(spacing: 32) {
            RoundedRectangle(cornerRadius: 38.5, style: .continuous)
                .modifier(SoftBlueShadow())
                .aspectRatio(1.0, contentMode: .fit)
                .foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 38.5,
                        style: .continuous
                    ).stroke(
                        Color("stackBackgroundColor"),
                        lineWidth: 10
                    ))
                .overlay (
                    Text(toDo.title)
                        .font(.system(size: 40))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("stackBackgroundColor"))
                    .padding(10)
            )
            
            Button(action: { self.saveToDo() }) {
                RoundedRectangle(cornerRadius: 39.5, style: .continuous)
                    .modifier(SoftBlueShadow())
                    .foregroundColor(.white)
                    .overlay(
                    RoundedRectangle(
                        cornerRadius: 38.5,
                        style: .continuous
                    ).stroke(
                        Color("stackBackgroundColor"),
                        lineWidth: 10
                    ))
                    .overlay(
                Image(systemName: "checkmark")
                .resizable()
                .foregroundColor(Color("stackBackgroundColor"))
                .padding(25)
                )
                }.frame(width:100, height: 100)
        }.padding(16)
    }
    
    func saveToDo() {
        self.toDo.completedAt = Date()
        
        do {
            try self.toDo.managedObjectContext?.save()
        } catch {
            //TODO: Figure this out
        }
    }
    
    func moveToDo() {
        self.toDo.location = "Store"
        
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

struct SoftBlueShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color(UIColor(red: 0.14, green: 0.696, blue: 1, alpha: 1)),
                radius: 14, x: -5, y: -8
            )
            .shadow(
                color: Color(UIColor(red: 0, green: 0.556, blue: 0.86, alpha: 1)),
                radius: 14, x: 8, y: 5
            )
    }
    
}
