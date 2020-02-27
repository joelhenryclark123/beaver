//
//  StoreView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData

struct StoreView: View {
    @EnvironmentObject var state: AppState
    
    @State var newToDoTitle: String = ""
    let footerHeight: CGFloat = 60
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("New", text: $newToDoTitle, onCommit: {
                    if self.newToDoTitle.isEmpty {
                        return
                    } else {
                        let _ = ToDo(
                            state: self.state,
                            title: self.newToDoTitle,
                            isActive: false
                        )
                        
                        self.newToDoTitle = ""
                    }
                })
                    .padding(.leading, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(height: 42)
                            .foregroundColor(Color.gray)
                            .opacity(0.3)
                )
                    .padding()
                
                List{
                    ForEach(state.storedToDos) { toDo in
                        StoreItem(toDo: toDo)
                    }.onDelete { (offsets) in
                        for index in offsets {
                            self.state.deleteFromStore(index)
                        }
                    }
                }
                
                Spacer().frame(height: footerHeight)
            }
            .navigationBarTitle("Ideas")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .clipShape(
            RoundedRectangle(
                cornerRadius: 39.5,
                style: .continuous)
        )
        .padding(8)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("stackBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            StoreView()
                .environmentObject(AppState())
        }
    }
}
