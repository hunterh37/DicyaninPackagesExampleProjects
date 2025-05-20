//
//  ImmersiveView.swift
//  DicyaninPlayground003
//
//  Created by Hunter Harris on 5/19/25.
//
import SwiftUI
import RealityKit
import RealityKitContent
import DicyaninThumbController

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        RealityView { content in
            // Create and add the green cube
            let cube = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .green, isMetallic: false)]
            )
            cube.position = SIMD3<Float>(0, 1.5, -0.5) // Position in front of the user
            
            // Add thumb control to the cube
            cube.addThumbControl(movementSpeed: 1)
            
            content.add(cube)
        }
        .task {
            // Start the shared thumb controller
            try? await ThumbController.shared.start()
        }
        .onDisappear {
            // Clean up when view disappears
            ThumbController.shared.stop()
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
