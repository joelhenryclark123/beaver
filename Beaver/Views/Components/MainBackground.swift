//
//  MainBackground.swift
//  Beaver
//
//  Created by Joel Clark on 4/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct MainBackground: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        LinearGradient(
            gradient: buildGradient(color: state.scene.color),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

//struct MainBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        MainBackground()
//        .environmentObject(AppState())
//    }
//}
