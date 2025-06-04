//
//  ContentView.swift
//  DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import RealityKit
import DicyaninMultiPeer

struct VisionContentView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
            
            Spacer()
            
            Button("Add Flower Model") {
                addFlowerModel()
            }
            .buttonStyle(.bordered)
            .padding()
            
            Button("Add Chicken Model") {
                addChickenModel()
            }
            .buttonStyle(.bordered)
            .padding()
            
            // Multi-device connection UI
            MultiDeviceConnectionView(displayName: "DicyaninPlayground005-visionOS")
                .background(.ultraThinMaterial)
        }
        .padding()
    }
    
    private func addFlowerModel() {
        // Create a new entity for the flower
        let flowerEntity = Entity()
        flowerEntity.name = "Flower"
        flowerEntity.position = SIMD3(x: 0, y: 1.0, z: -1.5)
        
        // Load the flower model
        if let flowerURL = Bundle.main.url(forResource: "Flower", withExtension: "usdz"),
           let flowerModel = try? ModelEntity.load(contentsOf: flowerURL) {
            // Add the model to our entity
            flowerEntity.addChild(flowerModel)
            
            // Set up sync component with a unique ID
            let syncId = "Flower_\(UUID().uuidString)"
            flowerEntity.components.set(SyncComponent(id: syncId))
            
            // Set up model sync component with the model data
            if let modelData = try? Data(contentsOf: flowerURL) {
                var modelComponent = SyncModelComponent(modelData: modelData)
                modelComponent.modelURL = flowerURL
                modelComponent.modelData = modelData
                flowerEntity.components.set(modelComponent)
            }
            
            // Add input target component for interaction
            flowerEntity.components.set(InputTargetComponent())
            flowerEntity.components.set(CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.2))]))
            
            // Add to root entity
            rootEntity.addChild(flowerEntity)
            
            // Broadcast the new entity to all connected devices
            if let entityObservation = appModel.manager.entityObservation {
                let transform = SyncTransform(from: flowerEntity.transform)
                entityObservation.broadcastTransform(for: flowerEntity, transform: transform, includeModel: true)
            }
        }
    }
    
    private func addChickenModel() {
        // Create a new entity for the chicken
        let chickenEntity = Entity()
        chickenEntity.name = "ArrowIndicator"
        chickenEntity.position = SIMD3(x: 0.5, y: 1.0, z: -1.5) // Slightly offset from flower position
        
        // Load the chicken model
        if let chickenURL = Bundle.main.url(forResource: "ArrowIndicator", withExtension: "usdz"),
           let chickenModel = try? ModelEntity.load(contentsOf: chickenURL) {
            // Add the model to our entity
            chickenEntity.addChild(chickenModel)
            
            // Set up sync component with a unique ID
            let syncId = "Arrow_\(UUID().uuidString)"
            chickenEntity.components.set(SyncComponent(id: syncId))
            
            // Set up model sync component with the model data
            if let modelData = try? Data(contentsOf: chickenURL) {
                var modelComponent = SyncModelComponent(modelData: modelData)
                modelComponent.modelURL = chickenURL
                modelComponent.modelData = modelData
                chickenEntity.components.set(modelComponent)
            }
            
            // Add input target component for interaction
            chickenEntity.components.set(InputTargetComponent())
            chickenEntity.components.set(CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.2))]))
            
            // Add to root entity
            rootEntity.addChild(chickenEntity)
            
            // Broadcast the new entity to all connected devices
            if let entityObservation = appModel.manager.entityObservation {
                let transform = SyncTransform(from: chickenEntity.transform)
                entityObservation.broadcastTransform(for: chickenEntity, transform: transform, includeModel: true)
            }
        }
    }
}

#Preview {
    VisionContentView()
}
