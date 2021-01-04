//
//  CanvasView.swift
//  Beaver
//
//  Created by Joel Clark on 12/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper

struct CanvasView: View {
    @EnvironmentObject var state: AppState
    @ObservedObject var canvasLoader = CanvasLoader.shared
    @State var showingAuth = true
    
    var body: some View {
        Group {
            if showingAuth {
                CanvasAuthView(showing: $showingAuth)
            } else {
                courses
            }
        }.onAppear(perform: {
            if KeychainWrapper.standard.string(forKey: .CanvasToken) != nil {
                showingAuth = false
            }
        }).onReceive(NotificationCenter.default.publisher(for: .invalidCanvasAccessToken), perform: { _ in
            showingAuth = true
        })
    }
    
    var courses: some View {
        LazyVStack {
            ForEach(canvasLoader.courses, id: \.self) { course in
                CourseView(course: course)
            }
        }.onAppear(perform: {
            CanvasLoader.shared.loadCourses(context: state.context)
        })
    }
}
