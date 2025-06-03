//
//  ImmersiveView.swift
//  DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import RealityKit
import DicyaninMultiDeviceMP

// Create your root entity
let rootEntity = Entity()

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    
    init() {
        // Add some 3D content
        let box = ModelEntity(mesh: .generateBox(size: 0.3))
        box.position = SIMD3(x: 0, y: 1.5, z: -2)
        box.name = "DraggableBox"
        box.components.set(InputTargetComponent())
        box.generateCollisionShapes(recursive: true)
        rootEntity.addChild(box)
        
        let box2 = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .red, isMetallic: true)])
        box2.position = SIMD3(x: -0.2, y: 0.3, z: -0.3)
        box2.name = "DraggableBox2"
        box2.components.set(InputTargetComponent())
        box2.generateCollisionShapes(recursive: true)
        rootEntity.addChild(box2)
    }
    
    var body: some View {
        RealityView { content in
            // Create a sync root entity
            let syncRoot = Entity()
            syncRoot.name = "SyncRoot"
            
            // Add your content as a child
            syncRoot.addChild(rootEntity)
            
            // Add to the scene
            content.add(syncRoot)
            
            // Start observing
            appModel.manager.startObserving(rootEntity: syncRoot)
        } update: { content in
            // Handle any updates if needed
        }
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    let entity = value.entity
                    // Update position based on drag
                    let newPosition = value.convert(value.location3D, from: .local, to: .scene)
                    
                    // Only update and broadcast if position actually changed
                    if entity.position != newPosition {
                        entity.position = newPosition
                        entity.broadcastTransformUpdate(manager: appModel.manager)
                    }
                }
        )
        .overlay(alignment: .bottom) {
            MultiDeviceConnectionView(displayName: "DicyaninPlayground005-visionOS")
                .background(.ultraThinMaterial)
        }
        .onAppear {
            appModel.immersiveSpaceState = .open
        }
        .onDisappear {
            appModel.immersiveSpaceState = .closed
        }
    }
}

#Preview {
    ImmersiveView()
}
