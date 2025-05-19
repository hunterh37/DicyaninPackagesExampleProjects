//
//  ContentView.swift
//  DicyaninPlayground001
//
//  Created by Hunter Harris on 5/11/25.
//

import SwiftUI
import RealityKit
import DicyaninHandTracking
import DicyaninEntityDebugger

struct ContentView: View {
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
            ToolViewButton()
            DebugViewButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
