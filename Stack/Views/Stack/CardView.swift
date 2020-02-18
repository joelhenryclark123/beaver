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
    var toDo: ToDo
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38.5, style: .continuous)
                .foregroundColor(Color.white)
                
            Text(toDo.title)
                .font(.system(size: 34))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                
            VStack {
                Spacer()
                Button(action: {
                    self.toDo.completedAt = Date()
                    
                    do {
                        try self.toDo.managedObjectContext?.save()
                    } catch {
                        //TODO: Figure this out
                    }
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("stackBackgroundColor"))
                }.scaleEffect(3.0)
                    .padding(.bottom, 50)
            }
        }.opacity(opacity)
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
