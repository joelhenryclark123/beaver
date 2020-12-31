//
//  StoreView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAnalytics
import Combine

struct StoreView: View {
    // MARK: - Properties
    @EnvironmentObject var state: AppState
    @State var nudging: Bool = false
    
    var instruction: String = "Pick today's tasks"
    
    enum Tab: String, Equatable, CaseIterable {
        case personal = "Personal"
        case school = "Canvas"
        
        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }
    
    @State var selectedTab: Tab = .personal
    
    // MARK: - Views
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                #if DEBUG
                if selectedTab == .personal {
                    personalListView
                } else {
                    CanvasView()
                }
                #else
                personalListView
                #endif
                
                
                Spacer()
                    .frame(height: 80)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: Subviews
    var header: some View {
        VStack(alignment: .leading) {
            Text("Plan Your Day")
                .modifier(FocalistFont(font: .heading2))
                .foregroundColor(Color("accentWhite"))
            
            switcher
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    var switcher: some View {
        HStack(spacing: 12) {
            ForEach(Tab.allCases, id: \.self) { value in
                Text(value.localizedName)
                    .modifier(FocalistFont(font: .mediumText))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color("accentWhite").opacity(value == selectedTab ? 1.0 : 0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .onTapGesture {
                        self.selectedTab = value
                    }
            }
        }
    }
    var personalListView: some View {
        LazyVGrid(columns: [
            .init(.flexible()),
            .init(.flexible())
        ], spacing: 8) {
            ForEach(state.storeList, id: \.self) { toDo in
                NewStoreItem(toDo: toDo)
            }
        }.padding()
    }
    
    var emptyState: some View {
        VStack {
            VStack {
                Text("Empty!")
                    .modifier(FocalistFont(font: .heading1))
                Text("Tap the add button to get started")
                    .modifier(FocalistFont(font: .mediumText))
            }.foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Previews
//struct StoreView_Previews: PreviewProvider {
//    static let context: NSManagedObjectContext = {
//        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let toDos = try! mc.fetch(ToDo.fetchRequest())
//        for toDo in toDos {
//            (toDo as! ToDo).delete()
//        }
//
//        let _ = ToDo(
//            context: mc,
//            title: "Walk 100 miles",
//            isActive: false
//        )
//
//        //        let _ = ToDo(
//        //            context: mc,
//        //            title: "Walk 200 miles",
//        //            isActive: true
//        //        )
//        //
//        //        let _ = ToDo(
//        //            context: mc,
//        //            title: "Walk 300 miles",
//        //            isActive: true
//        //        )
//        //
//        //        let _ = ToDo(
//        //            context: mc,
//        //            title: "Walk 400 miles",
//        //            isActive: true
//        //        )
//
//        return mc
//    }()
//
//    static let state = AppState(moc: context)
//
//    static var previews: some View {
//        ZStack {
//            MainBackground()
//                .environmentObject(state)
//
//            ZStack {
//                StoreView()
//                    .environmentObject(state)
//                    .frame(maxHeight: .infinity)
//
//                //                AddBar()
//                //                    .environmentObject(state)
//                //                    .frame(maxHeight: .infinity, alignment: .top)
//            }
//        }
//    }
//}
