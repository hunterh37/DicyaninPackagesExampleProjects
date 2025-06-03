//
//  DicyaninPlayground001.swift
//  DicyaninPlayground001
//
//  Created by Hunter Harris on 5/11/25.
//

import SwiftUI
import RealityFoundation

import DicyaninHandTracking
import DicyaninHandGesture
import DicyaninEntity
import DicyaninEntityManagement
import DicyaninEntityDebugger

@main
struct DicyaninPlayground001: App {
    
    @State private var appModel = AppModel()
    
    init() {
        DicyaninHandTracking.registerComponents()
    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        WindowGroup(id: "tool-view") {
            ToolView()
        }
        
        WindowGroup(id: "entity-debug-view") {
            EntityDebugView()
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveViewWithHandTracking()
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

