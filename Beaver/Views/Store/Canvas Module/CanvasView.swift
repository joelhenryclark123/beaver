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
//            KeychainWrapper.standard[.CanvasToken] = "1770~VcWaBnny5ouhJ1LCcNo8g9dE69kyfAbg6rpD5LMAm0rLOPKeXgwMU8sDtfNGNGUZ"
            if KeychainWrapper.standard.string(forKey: .CanvasToken) != nil {
                showingAuth = false
            }
        }).onReceive(NotificationCenter.default.publisher(for: .invalidCanvasAccessToken), perform: { _ in
            showingAuth = true
        })
    }
    
    var courses: some View {
        LazyVStack {
            if canvasLoader.betweenSemesters {
                Text("Enjoy the break!")
                    .padding(.top, 80)
                    .foregroundColor(Color("accentWhite"))
            } else {
                ForEach(canvasLoader.courses, id: \.self) { course in
                    CourseView(course: course)
                }
            }
        }.onAppear(perform: {
            canvasLoader.loadCourses(context: state.context)
        })
    }
}
