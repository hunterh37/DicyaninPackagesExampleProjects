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
            content.camera = .spatialTracking
            
            // Create a sync root entity
            let syncRoot = Entity()
            syncRoot.name = "SyncRoot"
            
            // Add your content as a child
            syncRoot.addChild(rootEntity)
            
            // Add to the scene
            content.add(syncRoot)
            
            // Start observing
            manager.startObserving(rootEntity: syncRoot)
            
            logger.info("Started observing sync root")
        } update: { content in
            // Update content if needed
        }
        .gesture(
            DragGesture()
                .targetedToEntity(where: .has(InputTargetComponent.self))
                .onChanged { value in
                    let entity = value.entity
                    
                    // Calculate new position based on drag delta
                    let sensitivity: Float = 0.01
                    let deltaX = Float(value.translation.width) * sensitivity
                    let deltaY = Float(-value.translation.height) * sensitivity
                    
                    // Update position
                    let newPosition = SIMD3<Float>(
                        entity.position.x + deltaX,
                        entity.position.y + deltaY,
                        entity.position.z
                    )
                    
                    // Only update and broadcast if position actually changed
                    if entity.position != newPosition {
                        entity.position = newPosition
                        entity.broadcastTransformUpdate(manager: manager)
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

#Preview {
    MobileContentView()
}
