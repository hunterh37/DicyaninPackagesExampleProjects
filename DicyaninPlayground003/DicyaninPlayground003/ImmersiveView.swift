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
import Combine

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @State private var thumbController: ThumbController?
    @State private var cancellables = Set<AnyCancellable>()
    @State private var direction: SIMD3<Float> = .zero
    @State private var magnitude: Float = 0.0
    @State private var isActive: Bool = false
    @State private var cubeEntity: ModelEntity?

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
            
            // Create and add the green cube
            let cube = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .green, isMetallic: false)]
            )
            cube.position = SIMD3<Float>(0, 1.5, -0.5) // Position in front of the user
            content.add(cube)
            cubeEntity = cube
        } update: { content in
            // Update cube position based on thumb controller input
            if let cube = cubeEntity {
                let moveSpeed: Float = 0.01
                let newPosition = cube.position + (direction * magnitude * moveSpeed)
                cube.position = newPosition
            }
        }
        .task {
            // Initialize and start the thumb controller
            thumbController = ThumbController(handSide: .right)
            do {
                try await thumbController?.start()
                
                // Set up publishers for direction, magnitude, and active state
                thumbController?.$direction
                    .sink { newDirection in
                        direction = newDirection
                    }
                    .store(in: &cancellables)
                
                thumbController?.$magnitude
                    .sink { newMagnitude in
                        magnitude = newMagnitude
                    }
                    .store(in: &cancellables)
                
                thumbController?.$isActive
                    .sink { newIsActive in
                        isActive = newIsActive
                    }
                    .store(in: &cancellables)
            } catch {
                print("Failed to start thumb controller: \(error)")
            }
        }
        .onDisappear {
            // Clean up when view disappears
            thumbController?.stop()
            cancellables.removeAll()
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
