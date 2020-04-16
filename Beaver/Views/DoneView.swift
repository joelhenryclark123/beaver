//
//  DoneView.swift
//  Beaver
//
//  Created by Joel Clark on 3/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct DoneView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark")
                .resizable()
                .frame(maxWidth: 120, maxHeight: 120)
                .scaledToFit()

            Text("Done")
                .modifier(FocalistFont(font: .heading1))
            Text("Come back tomorrow!")
                .modifier(FocalistFont(font: .mediumTextSemibold))
            
        }.foregroundColor(Color("accentWhite"))

    }
}

struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        LinearGradient(
            gradient: buildGradient(color: .accentGreen), startPoint: .top, endPoint: .bottom
        ).edgesIgnoringSafeArea(.all)
        DoneView()
        }
    }
}
