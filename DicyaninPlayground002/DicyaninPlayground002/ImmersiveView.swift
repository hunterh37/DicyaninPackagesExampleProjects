//
//  ImmersiveView.swift
//  DicyaninPlayground002
//
//  Created by Hunter Harris on 5/19/25.
//
import SwiftUI
import RealityKit
import DicyaninSharePlay

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @State private var content: RealityViewContent?
    
    var body: some View {
        RealityView { content in
            
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive") {
                content.add(immersiveContentEntity)
                
                // Notify other participants about the new entity
                let message = EntityStateMessage(
                    entityId: immersiveContentEntity.id.description,
                    isActive: true,
                    modelName: "Immersive"
                )
                SharePlayManager.sendMessage(message: message)
            }
        } update: { content in
            
        }
        .onAppear {
            // Register message handlers
            registerMessageHandlers()
            
            // Start SharePlay
            SharePlayManager.shared.startSharePlay()
        }
    }
    
    private func registerMessageHandlers() {
        // Register transform handler
        let transformHandler = EntityTransformHandler { message in
            guard let entity = content?.entities.first(where: { $0.id.description == message.entityId }) else { return }
            
            // Update entity transform
            entity.position = message.position
            entity.orientation = message.rotation
            entity.scale = message.scale
        }
        MessageHandlerRegistry.shared.register(transformHandler)
        
        // Register state handler
        let stateHandler = EntityStateHandler { message in
            if message.isActive {
                // Create new entity
                Task {
                    if let newEntity = try? await Entity(named: message.modelName) {
                        content?.add(newEntity)
                    }
                }
            } else {
                // Remove entity
                if let entity = content?.entities.first(where: { $0.id.description == message.entityId }) {
                    content?.remove(entity)
                }
            }
        }
        MessageHandlerRegistry.shared.register(stateHandler)
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
