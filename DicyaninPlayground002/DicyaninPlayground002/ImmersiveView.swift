//
//  ImmersiveView.swift
//  DicyaninPlayground002
//
//  Created by Hunter Harris on 5/19/25.
//
import SwiftUI
import RealityKit
import DicyaninSharePlay

var myEntity = Entity()

struct MyEntityComponent: RealityKit.Component { }

struct IdentifiableSharePlayObjectComponent: RealityKit.Component {
    var objectId: String
}

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @State private var content: RealityViewContent?
    
    var body: some View {
        RealityView { content in
            self.content = content
            myEntity = Entity()
            content.add(myEntity)
            
            if let flowers = try? await Entity(named: "Flower") {

                myEntity.addChild(flowers)
                
                myEntity.components.set(IdentifiableSharePlayObjectComponent(objectId: flowers.id.description))
                myEntity.components.set(MyEntityComponent())
                myEntity.components.set(InputTargetComponent())
                myEntity.generateCollisionShapes(recursive: true)
                
                // Notify other participants about the new entity
                let message = EntityStateMessage(
                    entityId: flowers.id.description,
                    isActive: true,
                    modelName: "Flower"
                )
                SharePlayManager.sendMessage(message: message)
            }
        } update: { content in
            
        }
        .gesture(dragGesture)
        .onAppear {
            // Register message handlers
            registerMessageHandlers()
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
                        newEntity.components.set(IdentifiableSharePlayObjectComponent(objectId: message.entityId))
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
    
    // When moving an entity, send EntityTransformMessage to tell others
    // in the SharePlay session to update this object position
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                guard let parent = value.entity.parent else { return }
                value.entity.position = value.convert(value.location3D, from: .local, to: parent)
                
                if value.entity.components.has(MyEntityComponent.self) {
                    let newMessage = EntityTransformMessage(
                        entityId: value.entity.id.description,
                        position: value.entity.position,
                        rotation: value.entity.orientation,
                        scale: value.entity.scale
                    )
                    SharePlayManager.sendMessage(message: newMessage)
                }
            }
            .onEnded({ value in
                
            })
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
