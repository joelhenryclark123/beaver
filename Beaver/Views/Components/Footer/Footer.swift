//
//  Footer.swift
//  Beaver
//
//  Created by Joel Clark on 11/24/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI

struct Footer: View {
    @EnvironmentObject var state: AppState
    @State var nudge: Bool = false
    @Binding var adding: Bool
    
    @State var showingCompleteAlert: Bool = false
    
    var body: some View {
        HStack {
            // Left Item
            switch state.scene {
            case .middle:
                NudgeButton(nudging: .constant(false), icon: .previous, action: { state.editDay() })
            case .focusing:
                NudgeButton(nudging: .constant(false), icon: .previous, action: { self.state.unfocus() })
            default:
                NudgeButton(nudging: .constant(false), icon: .previous, action: { }).hidden()
            }
            
            Spacer()
            
            AddButton(action: { adding.toggle() })
            
            Spacer()
            
            // Right Item
            switch state.scene {
            case .beginning:
                NudgeButton(nudging: $nudge, icon: .next, action: { state.startDay() })
            case .middle:
                NudgeButton(nudging: $nudge, icon: .check, action: { self.showingCompleteAlert.toggle() })
            default:
                NudgeButton(nudging: $nudge, icon: .previous, action: { }).hidden()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange).receive(on: DispatchQueue.main)) { _ in
            setNudge()
        }.onAppear{
            setNudge()
        }
        .alert(isPresented: $showingCompleteAlert) {
            Alert(
                title: Text("Complete Day"), message: Text("Are you sure?"),
                primaryButton: .default(Text("Yup!"), action: self.state.completeDay),
                secondaryButton: .cancel(Text("Not yet"), action: { showingCompleteAlert.toggle() })
            )
        }
    }
    
    private func setNudge() {
        DispatchQueue.main.async {
            switch state.scene {
            case .beginning:
                self.nudge = state.storeList.contains(where: { $0.isActive })
            case .middle:
                self.nudge = state.activeList.allSatisfy({ $0.isComplete })
            default:
                return
            }
        }
    }
}

struct Footer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .accentPink), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Footer(adding: .constant(false))
                    .environmentObject(AppState(moc: ContentView_Previews.demoContext))
                    .padding()
            }
        }
    }
}
