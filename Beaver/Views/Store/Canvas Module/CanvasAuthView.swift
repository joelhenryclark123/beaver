//
//  CanvasAuthView.swift
//  Beaver
//
//  Created by Joel Clark on 1/2/21.
//  Copyright © 2021 MyCo. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper

struct CanvasAuthView: View {
    @State var accessToken: String = ""
    @Binding var showing: Bool
    
    var body: some View {
        TextField("Canvas Access Token", text: $accessToken, onCommit: {
            saveToKeychain()
        })
    }
    
    func saveToKeychain() {
        CanvasLoader.shared.setAccessToken(accessToken)
        showing = false
    }
}
