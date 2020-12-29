//
//  CourseView.swift
//  Beaver
//
//  Created by Joel Clark on 12/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct CourseView: View {
    @ObservedObject var course: CanvasCourse
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            label
                .padding(.leading, 16)
            
            taskScroller
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var label: some View {
        Text(course.name ?? "ERROR")
            .modifier(FocalistFont(font: .heading4))
            .foregroundColor(Color("accentWhite"))
            .multilineTextAlignment(.leading)
    }
    
    var taskScroller: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                Spacer()
                    .frame(width: 16, height: 143)
                
                ForEach(Array(course.assignments! as Set), id: \.self) { assignment in
                    NewStoreItem(toDo: assignment as! ToDo)
                        .frame(width: 143, height: 143)
                        .padding(.bottom, 16)
                }
                
                Spacer()
                    .frame(width: 16, height: 143)
            }
        }
    }
}

struct CanvasAssignmentView: View {
    @ObservedObject var assignment: CanvasAssignment
    
    var body: some View {
        ZStack {
            background
            
            Text(assignment.title)
                .modifier(FocalistFont(font: .mediumText))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("accentWhite"))
                .padding(4)
        }
        .frame(width: 143, height: 143)
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundColor(Color("unselectedBlack"))
    }
}

//struct CourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseView()
//    }
//}
