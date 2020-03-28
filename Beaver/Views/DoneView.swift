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
                .foregroundColor(Color("accentWhite"))

            Text("Done")
                .modifier(FocalistFont(font: .heading1))
                .foregroundColor(.white)
            Text("Come back tomorrow!")
                .modifier(FocalistFont(font: .mediumTextSemibold))
                .foregroundColor(.white)
            Text("(or save a task for later with the add bar)")
                .modifier(FocalistFont(font: .smallText))
                .foregroundColor(Color("dimWhite"))
        }
    }
}

struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        DoneView()
    }
}
