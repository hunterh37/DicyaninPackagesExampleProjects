//
//  ContentView.swift
//  iPhone-DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import RealityKit
import DicyaninMultiDeviceMP
import os.log

struct MobileContentView: View {
    @State private var isShowingSettings = false
    @StateObject private var manager = MultiDeviceManager(displayName: "DicyaninPlayground005-iPhone")
    private let logger = Logger(subsystem: "com.dicyanin.playground", category: "iPhone-ContentView")
    
    // Create your root entity
    let rootEntity = Entity()
    
    init() {
        // Add some 3D content
        let box = ModelEntity(mesh: .generateBox(size: 0.3))
        box.position = SIMD3(x: 0, y: 1.5, z: -2)
        box.name = "DraggableBox"
        box.components.set(InputTargetComponent())
        box.components.set(SyncComponent(id: "DraggableBox"))
        box.generateCollisionShapes(recursive: true)
        rootEntity.addChild(box)
        
        let box2 = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .red, isMetallic: true)])
        box2.position = SIMD3(x: -0.2, y: 0.3, z: -0.3)
        box2.name = "DraggableBox2"
        box2.components.set(InputTargetComponent())
        box2.components.set(SyncComponent(id: "DraggableBox2"))
        box2.generateCollisionShapes(recursive: true)
        rootEntity.addChild(box2)
    }
    
    var body: some View {
        ZStack {
            RealityView { content in
                content.camera = .spatialTracking
                // Create a sync root entity
                let syncRoot = Entity()
                syncRoot.name = "SyncRoot"
                syncRoot.components.set(SyncComponent(id: "SyncRoot"))
                
                // Add your content as a child
                syncRoot.addChild(rootEntity)
                
                // Add to the scene
                content.add(syncRoot)
                
                // Start observing
                manager.startObserving(rootEntity: syncRoot)
                
                // Set up entity observation for synchronization
                if manager.entityObservation == nil {
                    manager.entityObservation = EntityObservation(
                        rootEntity: syncRoot,
                        onDataReceived: { data in
                            // Handle received data
                            manager.entityObservation?.handleReceivedData(data)
                        }
                    )
                }
                
                logger.info("Started observing sync root")
            } update: { content in
                // Update content if needed
            }
            .gesture(
                DragGesture()
                    .targetedToEntity(where: .has(InputTargetComponent.self))
                    .onChanged { value in
                        // Convert screen coordinates to 3D space
                        let box = value.entity
                        
                        // Calculate new position based on drag delta
                        let sensitivity: Float = 0.01
                        let deltaX = Float(value.translation.width) * sensitivity
                        let deltaY = Float(-value.translation.height) * sensitivity
                        
                        // Create new transform
                        var transform = box.transform
                        let newPosition = SIMD3<Float>(
                            transform.translation.x + deltaX,
                            transform.translation.y + deltaY,
                            transform.translation.z
                        )
                        
                        // Only update and broadcast if position actually changed
                        if transform.translation != newPosition {
                            transform.translation = newPosition
                            box.transform = transform
                            
                            // Broadcast the transform update
                            if let entityObservation = manager.entityObservation {
                                entityObservation.broadcastTransform(for: box, transform: SyncTransform(from: transform))
                    }
                        }
                    }
            )
            
            // Multi-device connection UI
            VStack {
                Spacer()
                MultiDeviceConnectionView(displayName: "DicyaninPlayground005-iPhone")
                    .background(.ultraThinMaterial)
                    .onChange(of: manager.isConnected) { newValue in
                        logger.info("Connection state changed to: \(newValue)")
                    }
                    .onChange(of: manager.connectedPeers) { newPeers in
                        logger.info("Connected peers changed: \(newPeers.count) peers")
                        for peer in newPeers {
                            logger.info("Connected peer: \(peer.displayName)")
                        }
                    }
            }
        }
    }
}

#Preview {
    MobileContentView()
}
