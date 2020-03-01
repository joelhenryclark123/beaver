//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var state: AppState
    
    var toDo: ToDo
    var body: some View {
        RaisedRectangle()
            .overlay (
                Text(self.toDo.title)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 40))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("stackBackgroundColor"))
                    .opacity(self.state.currentScene == .active ? 1.0 : 0.0)
                    .padding(10)
            )
            .scaleEffect(self.state.currentScene == .active ? 1.0 : 0.25)
            .animation(.easeOut(duration: 0.2))
    }
}

struct CardView_Previews: PreviewProvider {
    static let context = ContentView_Previews.context
    static let state = AppState()
    
    static var previews: some View {
            CardView(
                toDo: ToDo(
                    context: context,
                    title: "Walk 100 miles",
                    isActive: false)
            ).previewLayout(.sizeThatFits)
                .environmentObject(state)
    }
}

struct RaisedRectangle: View {
    var body: some View {
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
                )
        )
    }
}