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
    @Namespace private var daySpace
    
    @State var focusing: Bool = false
    @State private var focusedToDos = [ToDo]()
    
    var body: some View {
        Group {
            if focusing {
                CardView(toDo: focusedToDos.first!)
                    .matchedGeometryEffect(id: focusedToDos.first!.geometryId.uuidString, in: daySpace)
                    .transition(.offset())
                    .frame(maxHeight: .infinity)
                    .padding()
                    .zIndex(1)
            } else {
                TaskGrid(namespace: daySpace, list: state.activeList)
                    .zIndex(0)
                    .opacity(focusing ? 0.0 : 1.0)
            }
        }
        .animation(.spring(blendDuration: 0.2), value: focusing)
        .onAppear(perform: {
            refocus()
        })
        .onChange(of: state.focusedToDo, perform: { newValue in
            refocus()
        })
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
    
    func refocus() {
        if let newFocus = self.state.focusedToDo {
            if focusedToDos.first != newFocus {
                focusedToDos.removeAll()
                focusedToDos.insert(self.state.focusedToDo!, at: 0)
            }
            focusing = true
        } else {
            focusing = false
        }
    }
}


struct DayView_Previews: PreviewProvider {
    static let demoContext: NSManagedObjectContext = {
        let mc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let toDos = try! mc.fetch(ToDo.fetchRequest())
        for toDo in toDos {
            (toDo).delete()
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
            MainBackground(scene: .constant(state.scene))

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
