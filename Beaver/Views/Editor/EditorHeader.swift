//
//  EditorHeader.swift
//  Beaver
//
//  Created by Joel Clark on 1/15/22.
//  Copyright © 2022 MyCo. All rights reserved.
//

import SwiftUI

struct EditorHeader: View {
    @Binding var destination: Scene
//    @State var destination = Scene.beginning
    
    var body: some View {
        HStack {
            NudgeButton(
                scene: $destination,
                nudging: .constant(false),
                icon: .previous
            ) {
                print("previous")
            }
            
            Spacer()
            
            DestinationSwitcher(destination: $destination)
            
            Spacer()
            
            NudgeButton(
                scene: $destination,
                nudging: .constant(false),
                icon: .next) {
                print("add")
            }
        }
    }
}

struct EditorHeader_Previews: PreviewProvider {
    static var scene = Scene.beginning
    
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: buildGradient(color: scene.color),
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            
            EditorHeader(destination: .constant(scene))
//            EditorHeader()
        }
    }
}
