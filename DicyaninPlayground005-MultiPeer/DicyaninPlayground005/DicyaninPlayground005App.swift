//
//  DicyaninPlayground005App.swift
//  DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import DicyaninMultiDeviceMP

@main
struct DicyaninPlayground005App: App {
    
    @State private var appModel = AppModel()
    
    init() {
        MultiDeviceManager.registerComponents()
    }
    
    var body: some Scene {
        WindowGroup {
            VisionContentView()
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
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
