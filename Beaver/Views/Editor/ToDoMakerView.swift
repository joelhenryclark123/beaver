//
//  ToDoMakerView.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct ToDoMakerView: View {
    @State var destination: Scene = .beginning
    
    var body: some View {
        ZStack {
            background
            
            VStack {
                EditorHeader(destination: $destination)
                
                Spacer()
                
                Rectangle()
                    .foregroundColor(.white)
                    .aspectRatio(1.0, contentMode: .fit)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    var background: some View {
        ZStack {
            LinearGradient(
                gradient: buildGradient(color: destination.color),
                startPoint: .top,
                endPoint: .bottom
            )
            
            Color.black.opacity(0.3)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ToDoMakerView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoMakerView()
    }
}
