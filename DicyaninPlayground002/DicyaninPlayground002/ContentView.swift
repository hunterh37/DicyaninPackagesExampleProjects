//
//  ContentView.swift
//  DicyaninPlayground002
//
//  Created by Hunter Harris on 5/19/25.
//

import SwiftUI
import RealityKit
import DicyaninSharePlay

struct ContentView: View {
    var body: some View {
        VStack {
            
            HStack {
                ToggleImmersiveSpaceButton()
                OpenSharePlayListButton()
            }
            
            DicyaninSharePlayStatusView()
        }
    }
}

struct OpenSharePlayListButton: View {
    @Environment(\.openWindow) private var openWindow
    var body: some View {
        Button {
            openWindow(id: "shareplay-playerlist")
        } label: {
            Label("Player List", systemImage: "person.2")
        }
        .fontWeight(.semibold)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
