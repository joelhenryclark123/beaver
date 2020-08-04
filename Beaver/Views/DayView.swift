//
//  CardView.swift
//  Stack
//
//  Created by Joel Clark on 2/14/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAnalytics


struct DayView: View {
    @EnvironmentObject var state: AppState
    @State var showingAlert: Bool = false
    
    func completeDay() -> Void {
        self.state.activeList.forEach({ $0.totallyFinish() })
        
        #if DEBUG
        #else
        Analytics.logEvent("completedDay", parameters: nil)
        #endif
    }
    
    var body: some View {
        let showingButton: Bool = self.state.activeList.allSatisfy({
            $0.completedAt != nil && $0.isActive == true
        })
        
        return ZStack {
            if (showingButton) {
                WideButton(.accentGreen, "Complete") {
                    self.completeDay()
                }
                .zIndex(1)
            }
            
            VStack {
                if self.state.focusedToDo != nil {
                    Spacer()
                    CardView(toDo: self.state.focusedToDo!)
                        .padding()
                        .zIndex(0)
                    Spacer()
                }
                else {
                    Spacer()
                    taskGrid
                        .padding()
                        .zIndex(0)
                    Spacer()
                }
                
                Text("Tap to complete\nLong press for focus")
                    .foregroundColor(Color("dimWhite"))
                    .modifier(FocalistFont(font: .smallTextSemibold))
                    .multilineTextAlignment(.center)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification), perform: { _ in
            self.showingAlert = true
        })
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Do you want to change your list?"),
                primaryButton: .default(Text("Yup!"), action: {
                    self.showingAlert = false
                    self.state.editDay()
                }), secondaryButton: .cancel(Text("Nope."), action: {
                    self.showingAlert = false
                }))
        }
    }
    
    var taskGrid: some View {
        let columns: [GridItem] = [
            .init(.flexible()),
            .init(.flexible())
        ]
        
        return ScrollView{
            VStack {
                Spacer().frame(height: 60)
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(self.state.activeList, id: \.self) { toDo in
                        CardView(toDo: toDo)
                    }
                }
                
                Spacer().frame(height: 60)
            }
        }
    }
}


struct DayView_Previews: PreviewProvider {
    static let demoContext: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let toDos = try! mc.fetch(ToDo.fetchRequest())
        for toDo in toDos {
            (toDo as! ToDo).delete()
        }
        
        let list: [ToDo] = [
            ToDo(
                context: mc,
                title: "Walk 100 miles",
                isActive: false
            ),
            ToDo(
                context: mc,
                title: "Walk 200 miles",
                isActive: false
            ),
            ToDo(
                context: mc,
                title: "Walk 300 miles",
                isActive: false
            ),
            ToDo(
                context: mc,
                title: "Walk 400 miles",
                isActive: false
            )
        ]
        list.forEach({ $0.moveToDay() })
        
        return mc
    }()
    
    static let state = AppState(moc: demoContext)
    
    static var previews: some View {
        ZStack {
        MainBackground()
            .environmentObject(state)
        
        DayView()
            .environmentObject(state)
        }
    }
}

// MARK: - Shake gesture support
extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
