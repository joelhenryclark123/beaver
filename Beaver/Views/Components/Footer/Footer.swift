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
    @State var rightNudgeError: Int = 0
    
    var body: some View {
        HStack {
            // Left Item
            switch state.scene {
            case .middle:
                NudgeButton(scene: $state.scene, nudging: .constant(false), icon: .previous, action: { state.editDay() })
            case .focusing:
                NudgeButton(scene: $state.scene, nudging: .constant(false), icon: .previous, action: { self.state.unfocus() })
            default:
                NudgeButton(scene: $state.scene, nudging: .constant(false), icon: .previous, action: { }).hidden()
            }
            
            Spacer()
            
            AddButton(action: { adding.toggle() })
            
            Spacer()
            
            // Right Item
            switch state.scene {
            case .beginning:
                NudgeButton(scene: $state.scene, nudging: $nudge, icon: .next, action: { state.startDay() })
                    .modifier(Shake(animatableData: CGFloat(rightNudgeError)))
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "StartDayError")), perform: { _ in
                        withAnimation(.default) {
                            self.rightNudgeError += 1
                        }
                    })
            case .middle:
                NudgeButton(scene: $state.scene, nudging: $nudge, icon: .check, action: { self.showingCompleteAlert.toggle() })
            default:
                NudgeButton(scene: $state.scene, nudging: $nudge, icon: .previous, action: { }).hidden()
            }
        }
        .padding(.bottom, 34)
        .padding(.horizontal)
        .padding(.top, 8)
        .background(
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color(state.scene.color.rawValue + "Dark").opacity(0.0), location: 0),
                .init(color: Color(state.scene.color.rawValue + "Dark").opacity(0.2), location: 0.2),
                .init(color: Color(state.scene.color.rawValue + "Dark").opacity(0.5), location: 0.5),
                .init(color: Color(state.scene.color.rawValue + "Dark").opacity(0.8), location: 0.8),
                .init(color: Color(state.scene.color.rawValue + "Dark").opacity(1.0), location: 1.0),
            ]), startPoint: .top, endPoint: .bottom)
        )
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
                self.nudge = {
                    state.storeList.contains(where: { $0.isActive }) || !state.activeList.isEmpty
                }()
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
