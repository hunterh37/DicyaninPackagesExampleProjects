//
//  ExampleClass.swift
//  DicyaninPlayground001
//
//  Created by Hunter Harris on 5/18/25.
//

import Foundation

import SwiftUI
import RealityKit
import DicyaninEntityManagement
import DicyaninEntity
import DicyaninHandTracking

struct EntityViewTest: View {
    var body: some View {
        DicyaninEntityView(
            sceneId: "custom_scene",
            sceneName: "Custom Scene",
            sceneDescription: "A scene with custom entities",
            entityConfigurations: [
                DicyaninEntityConfiguration(
                    name: "Flower",
                    position: SIMD3<Float>(0, 0, -1),
                    scale: SIMD3<Float>(repeating: 2),
                    animation: ModelAnimation(type: .spin(speed: 2.0, axis: SIMD3<Float>(0, 1, 0)))
                )
            ],
            onEntityLoaded: { entity in
                entity.setupToolInteractionTarget(
                    stage: 0,
                    interactionData: ["index": index],
                    collisionGroup: .interactionTarget,
                    collisionMask: .tool
                ) {
                    
                    // Example: Change the entity's color when interacted with
                    if var modelComponent = entity.components[ModelComponent.self] {
                        modelComponent.materials = [SimpleMaterial(color: .green, isMetallic: false)]
                        entity.components[ModelComponent.self] = modelComponent
                    }
                }
            }
        )
    }
}
