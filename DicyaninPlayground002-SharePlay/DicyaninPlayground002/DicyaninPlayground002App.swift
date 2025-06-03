//
//  DicyaninPlayground002App.swift
//  DicyaninPlayground002
//
//  Created by Hunter Harris on 5/19/25.
//

import SwiftUI
import DicyaninSharePlay

@main
struct DicyaninPlayground002App: App {
    
    @State private var appModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        WindowGroup(id: "shareplay-playerlist") {
            PlayerListView()
                .environment(appModel)
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
