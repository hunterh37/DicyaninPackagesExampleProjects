# DicyaninPlayground005 🎮 🌐 🎯

> Transform your AR/VR experiences with seamless multi-device synchronization! This powerful framework enables real-time 3D content sharing between visionOS and iOS devices, perfect for collaborative AR experiences, interactive presentations, and immersive multi-user applications. 🚀

A multi-device AR/VR experience that demonstrates synchronized 3D content across visionOS and iOS devices.

## Features

- Real-time 3D model synchronization between visionOS and iOS devices
- Interactive 3D objects that can be manipulated across devices
- Multi-device connection management
- Support for USDZ model loading and synchronization

## Requirements

- Xcode 15.0+
- iOS 17.0+
- visionOS 1.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Build and run the visionOS target for the main experience
4. Build and run the iOS target for the mobile companion app

## Usage

### Setting Up Multi-Device Connection

1. Launch the visionOS app
2. Launch the iOS app
3. Both apps will automatically start advertising their presence
4. The connection UI will show available devices
5. Tap to connect the devices

### Adding 3D Content

1. In the visionOS app, use the "Add Dog Model" button to add a 3D flower model
2. The model will automatically sync to all connected devices
3. You can manipulate the model on either device:
   - On visionOS: Use hand gestures to move objects
   - On iOS: Use touch gestures to move objects

### Code Example

Here's how to set up a basic synchronized 3D scene:

```swift
// Create your root entity
let rootEntity = Entity()

// Set up RealityView
RealityView { content in
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
    
    // Set up entity observation
    if manager.entityObservation == nil {
        manager.entityObservation = EntityObservation(
            rootEntity: syncRoot,
            onDataReceived: { data in
                manager.entityObservation?.handleReceivedData(data)
            }
        )
    }
}
```

### Adding Synchronized 3D Models

```swift
// Create a new entity
let entity = Entity()
entity.name = "MyModel"
entity.position = SIMD3(x: 0, y: 1.0, z: -1.5)

// Load and add the model
if let modelURL = Bundle.main.url(forResource: "MyModel", withExtension: "usdz"),
   let model = try? ModelEntity.load(contentsOf: modelURL) {
    // Add the model to our entity
    entity.addChild(model)
    
    // Set up sync components
    let syncId = "Model_\(UUID().uuidString)"
    entity.components.set(SyncComponent(id: syncId))
    
    // Add model sync component
    if let modelData = try? Data(contentsOf: modelURL) {
        entity.components.set(SyncModelComponent(modelData: modelData))
    }
    
    // Add interaction components
    entity.components.set(InputTargetComponent())
    entity.components.set(CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.2))]))
    
    // Add to root entity
    rootEntity.addChild(entity)
    
    // Broadcast to connected devices
    if let entityObservation = manager.entityObservation {
        let transform = SyncTransform(from: entity.transform)
        entityObservation.broadcastTransform(for: entity, transform: transform)
    }
}
```

## Architecture

The app uses a multi-device synchronization system built on top of MultipeerConnectivity framework. Key components include:

- `MultiDeviceManager`: Handles device discovery and connection
- `EntityObservation`: Manages entity synchronization across devices
- `SyncComponent`: Tracks entity state and updates
- `SyncModelComponent`: Handles 3D model data synchronization

## Troubleshooting

1. If models don't appear on connected devices:
   - Ensure both devices are connected
   - Check that the model file exists in the bundle
   - Verify that the sync components are properly set up

2. If synchronization is delayed:
   - Check network connectivity
   - Ensure both apps are running the latest version
   - Verify that the devices are properly connected

## License

This project is licensed under the MIT License - see the LICENSE file for details. 