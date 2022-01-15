//
//  MainBackground.swift
//  Beaver
//
//  Created by Joel Clark on 4/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct MainBackground: View {
    @Binding var scene: Scene
    
    var body: some View {
        AnimatedBeavGradient(scene: $scene)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainBackground_Previews: PreviewProvider {
    static var previews: some View {
        MainBackground(scene: .constant(.middle))
    }
}
