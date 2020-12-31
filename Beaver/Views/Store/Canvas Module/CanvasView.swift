//
//  CanvasView.swift
//  Beaver
//
//  Created by Joel Clark on 12/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var state: AppState
    @ObservedObject var canvasLoader = CanvasLoader.shared
    
    var body: some View {
        LazyVStack {
            ForEach(canvasLoader.courses, id: \.self) { course in
                CourseView(course: course)
            }
        }.onAppear(perform: {
            CanvasLoader.shared.loadCourses(context: state.context)
        })
    }
}
