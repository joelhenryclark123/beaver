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
        RoundedRectangle(cornerRadius: 38.5, style: .continuous)
            .foregroundColor(Color.white)
            .shadow(radius: 3)
            .overlay (
                ZStack {
                    Text(toDo.title)
                        .font(.system(size: 34))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                    VStack {
                        Spacer()
                        Button(action: { self.saveToDo() }) {
                            Image(systemName: "checkmark")
                        }.scaleEffect(3.0)
                            .offset(y: -50)
                    }
                }
            )
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
