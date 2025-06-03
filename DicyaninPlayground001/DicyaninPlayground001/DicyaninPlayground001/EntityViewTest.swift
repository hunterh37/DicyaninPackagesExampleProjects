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



import SwiftUI
import RealityKit
import DicyaninHandTracking

struct ContentView2: View {
    @State private var handTracking = HandTracking()
    
    var body: some View {
        RealityView { content in
            // Start hand tracking
            handTracking.start(showHandVisualizations: true)
            
            // Add hand tracking visualization to the scene
            if let handEntity = handTracking.controlRootEntity {
                content.add(handEntity)
            }
            
            // Add your 3D content here
            let box = ModelEntity(mesh: .generateBox(size: 0.1))
            box.position = SIMD3<Float>(0, 0, -0.5)
            content.add(box)
            
            // Configure trigger entities for interaction
            let leftTrigger = handTracking.configureTriggerEntity(
                at: SIMD3<Float>(-0.3, 0, -0.5),
                stage: 0,
                interactionData: ["type": "leftButton"]
            ) {
                print("Left button pressed!")
            }
            
            let rightTrigger = handTracking.configureTriggerEntity(
                at: SIMD3<Float>(0.3, 0, -0.5),
                stage: 0,
                interactionData: ["type": "rightButton"]
            ) {
                print("Right button pressed!")
            }
            
            // Add trigger entities to the scene
            content.add(leftTrigger)
            content.add(rightTrigger)
            
        } update: { content in
            // Update hand tracking state
            if let handEntity = handTracking.controlRootEntity {
                content.add(handEntity)
            }
        }
    }
}
