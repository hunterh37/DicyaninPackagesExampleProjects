//
//  iPhone_DicyaninPlayground005App.swift
//  iPhone-DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import DicyaninMultiDeviceMP

@main
struct iPhone_DicyaninPlayground005App: App {
    
    init() {
        SyncComponent.registerComponent()
        SyncModelComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            MobileContentView()
        }
    }
}
