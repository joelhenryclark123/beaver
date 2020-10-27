//
//  AddBar.swift
//  Stack
//
//  Created by Joel Clark on 2/29/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
import CodeScanner

struct AddBar: View {
    @EnvironmentObject var state: AppState
    @State var version: Version = .unselected
    @State var text: String = ""
    
    let height: CGFloat = 48
    let cornerRadius: CGFloat = 24
    let horizontalPadding: CGFloat = 16
    let verticalPadding: CGFloat = 10
    
    enum Version {
        case unselected
        case selected
        
        mutating func toggle() {
            switch self {
            case .unselected:
                self = .selected
            case .selected:
                self = .unselected
            }
        }
    }
    
    func createToDo() -> Void {
        let _ = ToDo(
            context: self.state.context,
            title: self.text,
            isActive: false
        )
        
        self.text = ""
        
        #if DEBUG
        #else
        Analytics.logEvent("createdToDo", parameters: nil)
        #endif
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(height: height)
                .foregroundColor(
                    (version == Version.unselected) ? Color("dimWhite") : Color("accentWhite")
            )
                .modifier(FocalistShadow(option: self.version == .selected ? .heavy : .dark))
                .zIndex(0)
            
            HStack {
                TextField("", text: $text, onEditingChanged: { _ in self.version.toggle() }) {
                    if self.text.isEmpty { return }
                    else { self.createToDo() }
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .modifier(FocalistFont(font: .largeTextSemibold))
                .accentColor(Color(state.scene.color.rawValue))
                .zIndex(3)
                .padding(.leading, horizontalPadding)
                
                QRButton()
                    .padding(.trailing, horizontalPadding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct AddBar_Previews: PreviewProvider {
    static var previews: some View {
        AddBar()
            .environmentObject(StoreView_Previews.state)
    }
}

struct QRButton: View {
    @EnvironmentObject var state: AppState
    @State private var showingScanner = false
    
    var body: some View {
        Button(action: { handleClick() }) {
            Image(systemName: "qrcode.viewfinder")
                .accentColor(Color(state.scene.color.rawValue))
        }
        .sheet(isPresented: $showingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "https://jsonplaceholder.typicode.com/todos", completion: self.handleScan)
        }
    }
    
    func handleClick() {
        self.showingScanner = true
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.showingScanner = false
        
        switch result {
        case .success(let code):
            callAPI(URL(string: code)!)
        case .failure(let _):
            print("Scan error")
        }
    }
    
    func callAPI(_ url: URL) {
        API().getToDo(url: url) { (toDos) in
            for toDo in toDos {
                toDo.convertToCD(context: self.state.context)
            }
        }
    }
    
//    func readCSV(_ csv: String) {
//        csv.components(separatedBy: ", ").forEach({
//            if $0.isEmpty { return }
//            let _ = ToDo(context: state.context, title: $0, isActive: false)
//        })
//    }
}

