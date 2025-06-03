//
//  iPhone_DicyaninPlayground005App.swift
//  iPhone-DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import DicyaninMultiPeer

@main
struct iPhone_DicyaninPlayground005App: App {
    
    init() {
        MultiDeviceManager.registerComponents()
    }
    
    var body: some Scene {
        WindowGroup {
            MobileContentView()
        }
    }
}
