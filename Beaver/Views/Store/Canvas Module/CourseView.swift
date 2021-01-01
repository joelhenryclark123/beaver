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
        let assignments: [CanvasAssignment] = (Array(course.assignments! as Set) as! [CanvasAssignment]).filter { (assignment) -> Bool in
            assignment.isComplete == false
        }
        return ScrollView(.horizontal) {
            HStack(spacing: 8) {
                Spacer()
                    .frame(width: 16, height: 143)
                
                ForEach(assignments, id: \.self) { assignment in
                    VStack(spacing: 8) {
                        NewStoreItem(toDo: assignment as ToDo)
                            .frame(width: 143, height: 143)
                        
                        DueRow(assignment: assignment)
                    }
                    .padding(.bottom, 16)
                }
                
                Spacer()
                    .frame(width: 16, height: 143)
            }
        }
    }
    
    struct DueRow: View {
        @ObservedObject var assignment: CanvasAssignment
        
        var body: some View {
            if assignment.dueDate != nil {
                Text("Due " + assignment.mmddDueDate!)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .modifier(FocalistFont(font: .smallText))
                    .background(assignment.isActive ? Color("accentWhite") : Color("unselectedBlack"))
                    .foregroundColor(assignment.isActive ? Color("blackText") : Color("accentWhite"))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            } else {
                Text("not due")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .modifier(FocalistFont(font: .smallText))
                    .hidden()
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
