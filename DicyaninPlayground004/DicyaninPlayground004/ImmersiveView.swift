//
//  ImmersiveView.swift
//  DicyaninPlayground004
//
//  Created by Hunter Harris on 5/21/25.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            await content.add(createScene())
            
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}


// MARK: - Scene Creation
// This section contains the main scene creation function that sets up all entities
// and their components. The scene is created asynchronously on the main actor.

@MainActor
func createScene() async -> Entity {
    // Create root entity that will contain all other entities
    let rootEntity = Entity()
        // Create cube
    let cubeMesh0 = MeshResource.generateBox(size: SIMD3<Float>(0.4711761, 0.27459586, 0.13853276))
    var cubeMaterial0 = createMaterial(color: UIColor(hex: "#FF453A") ?? .white)
    cubeMaterial0.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    let cubeEntity0 = ModelEntity(mesh: cubeMesh0, materials: [cubeMaterial0])
    cubeEntity0.transform = createTransform(position: SIMD3<Float>(0.079850145, 1.2157052, -0.1612786), rotation: simd_quatf())
    cubeEntity0.scale = SIMD3<Float>(repeating: 1.0)

    // Add collision and input components
    cubeEntity0.generateCollisionShapes(recursive: true)
    cubeEntity0.components.set(InputTargetComponent(allowedInputTypes: .all))
    cubeEntity0.components.set(PhysicsBodyComponent(mode: .static))

    rootEntity.addChild(cubeEntity0)
    // Create cube
    let cubeMesh1 = MeshResource.generateBox(size: SIMD3<Float>(0.4394359, 0.112602234, 0.15280484))
    var cubeMaterial1 = createMaterial(color: UIColor(hex: "#20AE00") ?? .white)
    cubeMaterial1.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    let cubeEntity1 = ModelEntity(mesh: cubeMesh1, materials: [cubeMaterial1])
    cubeEntity1.transform = createTransform(position: SIMD3<Float>(0.07288403, 1.2605176, 0.012116648), rotation: simd_quatf())
    cubeEntity1.scale = SIMD3<Float>(repeating: 1.0)

    // Add collision and input components
    cubeEntity1.generateCollisionShapes(recursive: true)
    cubeEntity1.components.set(InputTargetComponent(allowedInputTypes: .all))
    cubeEntity1.components.set(PhysicsBodyComponent(mode: .static))

    rootEntity.addChild(cubeEntity1)
    // Create sphere
    let sphereMesh2 = MeshResource.generateSphere(radius: 0.09751946)
    var sphereMaterial2 = createMaterial(color: UIColor(hex: "#0061A7") ?? .white)
    sphereMaterial2.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    let sphereEntity2 = ModelEntity(mesh: sphereMesh2, materials: [sphereMaterial2])
    sphereEntity2.transform = createTransform(position: SIMD3<Float>(0.0792866, 1.4973073, -0.120876536), rotation: simd_quatf())
    sphereEntity2.scale = SIMD3<Float>(repeating: 1.0)

    // Add collision and input components
    sphereEntity2.generateCollisionShapes(recursive: true)
    sphereEntity2.components.set(InputTargetComponent(allowedInputTypes: .all))
    sphereEntity2.components.set(PhysicsBodyComponent(mode: .static))

    rootEntity.addChild(sphereEntity2)
    // Create sphere
    let sphereMesh3 = MeshResource.generateSphere(radius: 0.07976325)
    var sphereMaterial3 = createMaterial(color: UIColor(hex: "#79004E") ?? .white)
    sphereMaterial3.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    let sphereEntity3 = ModelEntity(mesh: sphereMesh3, materials: [sphereMaterial3])
    sphereEntity3.transform = createTransform(position: SIMD3<Float>(0.08793937, 1.3984169, 0.030182574), rotation: simd_quatf())
    sphereEntity3.scale = SIMD3<Float>(repeating: 1.0)

    // Add collision and input components
    sphereEntity3.generateCollisionShapes(recursive: true)
    sphereEntity3.components.set(InputTargetComponent(allowedInputTypes: .all))
    sphereEntity3.components.set(PhysicsBodyComponent(mode: .static))

    rootEntity.addChild(sphereEntity3)
    // Create sphere
    let sphereMesh4 = MeshResource.generateSphere(radius: 0.07410046)
    var sphereMaterial4 = createMaterial(color: UIColor(hex: "#FF00C1") ?? .white)
    sphereMaterial4.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    let sphereEntity4 = ModelEntity(mesh: sphereMesh4, materials: [sphereMaterial4])
    sphereEntity4.transform = createTransform(position: SIMD3<Float>(0.093745865, 1.3120509, 0.20136066), rotation: simd_quatf())
    sphereEntity4.scale = SIMD3<Float>(repeating: 1.0)

    // Add collision and input components
    sphereEntity4.generateCollisionShapes(recursive: true)
    sphereEntity4.components.set(InputTargetComponent(allowedInputTypes: .all))
    sphereEntity4.components.set(PhysicsBodyComponent(mode: .static))

    rootEntity.addChild(sphereEntity4)
    return rootEntity
}

// MARK: - System Code
// The following sections contain the system code that powers the scene.
// This includes helper functions, components, and systems that handle
// physics, animation, and other core functionality.

// MARK: - Imports

import RealityKit
import SwiftUI

// MARK: - Helper Functions

func createMaterial(color: UIColor) -> PhysicallyBasedMaterial {
    var material = PhysicallyBasedMaterial()
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: UIColor(red: red, green: green, blue: blue, alpha: alpha))
    material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.5)
    material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.0)
    return material
}

func createTransform(position: SIMD3<Float>, rotation: simd_quatf) -> Transform {
    var transform = Transform()
    transform.translation = position
    transform.rotation = rotation
    return transform
}

// MARK: - Data Structures
public struct CurveSample: Codable {
    var point: SolidBrushCurvePoint
    var parameter: Float
    var rotationFrame: simd_float3x3
    var curveDistance: Float
    var isEmpty: Bool = false

    var position: SIMD3<Float> {
        get { return point.position }
        set { point.position = newValue }
    }

    var tangent: SIMD3<Float> { rotationFrame.columns.2 }
    
    var radius: Float {
        get { return point.radius }
        set { point.radius = newValue }
    }
    
    init(point: SolidBrushCurvePoint, parameter: Float = 0, rotationFrame: simd_float3x3 = .init(diagonal: .one), curveDistance: Float = 0, isEmpty: Bool = false) {
        self.point = point
        self.parameter = parameter
        self.rotationFrame = rotationFrame
        self.curveDistance = curveDistance
        self.isEmpty = isEmpty
    }
    
    init() {
        self.init(point: SolidBrushCurvePoint(position: .zero, radius: .zero, color: .zero, roughness: .zero, metallic: .zero), isEmpty: true)
    }
    
    private enum CodingKeys: String, CodingKey {
        case point, parameter, rotationFrame, curveDistance, isEmpty
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        point = try container.decode(SolidBrushCurvePoint.self, forKey: .point)
        parameter = try container.decode(Float.self, forKey: .parameter)
        curveDistance = try container.decode(Float.self, forKey: .curveDistance)
        isEmpty = try container.decode(Bool.self, forKey: .isEmpty)
        
        let rotationArray = try container.decode([Float].self, forKey: .rotationFrame)
        guard rotationArray.count == 9 else {
            throw DecodingError.dataCorruptedError(forKey: .rotationFrame, in: container, debugDescription: "Expected 9 floats for rotationFrame")
        }
        rotationFrame = simd_float3x3(columns: (
            SIMD3<Float>(rotationArray[0], rotationArray[1], rotationArray[2]),
            SIMD3<Float>(rotationArray[3], rotationArray[4], rotationArray[5]),
            SIMD3<Float>(rotationArray[6], rotationArray[7], rotationArray[8])
        ))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(point, forKey: .point)
        try container.encode(parameter, forKey: .parameter)
        try container.encode(curveDistance, forKey: .curveDistance)
        try container.encode(isEmpty, forKey: .isEmpty)
        
        let rotationArray = [
            rotationFrame.columns.0.x, rotationFrame.columns.0.y, rotationFrame.columns.0.z,
            rotationFrame.columns.1.x, rotationFrame.columns.1.y, rotationFrame.columns.1.z,
            rotationFrame.columns.2.x, rotationFrame.columns.2.y, rotationFrame.columns.2.z
        ]
        try container.encode(rotationArray, forKey: .rotationFrame)
    }
}
public struct SolidBrushCurvePoint: Codable {
    var position: SIMD3<Float>
    var radius: Float
    var color: SIMD4<Float>
    var roughness: Float
    var metallic: Float
}
public struct MotionComponent: Component {
    var velocity: SIMD3<Float> = .zero
    var acceleration: SIMD3<Float> = .zero
    var mass: Float = 1.0
    var forces: [Force] = []
    
    struct Force: Codable {
        var acceleration: SIMD3<Float>
        var multiplier: Float
        var name: String
    }
}
public struct ObjectAnimationComponent: Component, Codable {
    var startTransform: Transform
    var endTransform: Transform
    var duration: TimeInterval
    var elapsedTime: TimeInterval = 0
    var isAnimating: Bool = true
    var reverse: Bool = true
    var loop: Bool = true
    var hasCompletedRoundTrip: Bool = false
    var animationPath: [CurveSample]?
    
    init(startTransform: Transform, endTransform: Transform, duration: TimeInterval, isAnimating: Bool = true, reverse: Bool = true, loop: Bool = true, animationPath: [CurveSample]? = nil) {
        self.startTransform = startTransform
        self.endTransform = endTransform
        self.duration = duration
        self.isAnimating = isAnimating
        self.reverse = reverse
        self.loop = loop
        self.animationPath = animationPath
    }
    
    init(from component: ObjectAnimationComponent) {
        self.startTransform = component.startTransform
        self.endTransform = component.endTransform
        self.duration = component.duration
        self.elapsedTime = component.elapsedTime
        self.isAnimating = component.isAnimating
        self.reverse = component.reverse
        self.loop = component.loop
        self.hasCompletedRoundTrip = component.hasCompletedRoundTrip
        self.animationPath = component.animationPath
    }
}
extension Transform {
    static func lerp(from start: Transform, to end: Transform, t: Float) -> Transform {
        let interpolatedTranslation = SIMD3(
            x: start.translation.x + (end.translation.x - start.translation.x) * t,
            y: start.translation.y + (end.translation.y - start.translation.y) * t,
            z: start.translation.z + (end.translation.z - start.translation.z) * t
        )
        
        let interpolatedRotation = simd_slerp(start.rotation, end.rotation, t)
        
        let interpolatedScale = SIMD3(
            x: start.scale.x + (end.scale.x - start.scale.x) * t,
            y: start.scale.y + (end.scale.y - start.scale.y) * t,
            z: start.scale.z + (end.scale.z - start.scale.z) * t
        )
        
        return Transform(scale: interpolatedScale, rotation: interpolatedRotation, translation: interpolatedTranslation)
    }
}
// MARK: - Motor System

struct MotorComponent: Component {
    var power: Float = 1.0 // Default power of the motor
    var direction: SIMD3<Float> = SIMD3<Float>(1, 0, 0) // Default direction
    var active: Bool = true // Whether the motor is active
}

final class MotorSystem: System {
    private let impulseStrength: Float = 0.01 // Control the strength of the impulse

    required init(scene: RealityKit.Scene) { }

    func update(context: SceneUpdateContext) {
        // Query entities with the MotorComponent
        let entities = context.scene.performQuery(
            EntityQuery(where: .has(MotorComponent.self))
        )

        for entity in entities {
            guard let motorComponent = entity.components[MotorComponent.self],
                  motorComponent.active,
                  var motionComponent = entity.components[MotionComponent.self] else {
                continue
            }
            
            // Calculate force based on motor power and direction
            let force = motorComponent.direction * motorComponent.power * impulseStrength
            
            // Add the force to the MotionComponent
            motionComponent.forces.append(MotionComponent.Force(
                acceleration: force,
                multiplier: 1.0,
                name: "motor"
            ))
            
            // Update the MotionComponent back to the entity
            entity.components[MotionComponent.self] = motionComponent
        }
    }
}

// MARK: - Animation System

final class AnimationSystem: System {
    required init(scene: RealityKit.Scene) { }

    func update(context: SceneUpdateContext) {
        let entities = context.scene.performQuery(
            EntityQuery(where: .has(ObjectAnimationComponent.self))
        )

        for entity in entities {
            guard var animationComponent = entity.components[ObjectAnimationComponent.self],
                  animationComponent.isAnimating else {
                continue
            }

            // Update elapsed time
            animationComponent.elapsedTime += context.deltaTime

            if let path = animationComponent.animationPath, !path.isEmpty {
                let pathDuration = animationComponent.duration
                let pathProgress = animationComponent.elapsedTime / pathDuration
                let sampleIndex = Int(pathProgress * Double(path.count - 1))
                let clampedIndex = max(0, min(sampleIndex, path.count - 1))
                let currentSample = path[clampedIndex]

                // Set the entity's transform based on the current sample
                entity.transform.translation = currentSample.position
                entity.transform.rotation = simd_quatf(currentSample.rotationFrame)

                // Check if the animation path is complete
                if animationComponent.elapsedTime >= pathDuration {
                    if animationComponent.loop {
                        // Reset elapsedTime to loop the animation
                        animationComponent.elapsedTime = 0
                    } else {
                        // Stop the animation if not looping
                        animationComponent.isAnimating = false
                    }
                }
                
                entity.components[ObjectAnimationComponent.self] = animationComponent
            }
        }
    }
}
// MARK: - SwiftUI View
// This section contains the SwiftUI view that displays the RealityKit content

struct ContentView4: View {
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                guard let parent = value.entity.parent else { return }
                value.entity.position = value.convert(value.location3D, from: .local, to: parent)
                if value.entity.components[PhysicsBodyComponent.self]?.mode == .dynamic {
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
                }
            }
            .onEnded { value in
                if value.entity.components[PhysicsBodyComponent.self]?.mode == .kinematic {
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                }
            }
    }
    
    var body: some View {
        RealityView { content in
            let scene = await createScene()
            content.add(scene)
            
        } update: { content in
            
        }
        .gesture(dragGesture)
    }
}

#Preview {
    ContentView4()
}
// MARK: - Color Extensions

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        let length = hexSanitized.count

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        if length == 6 {
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            return nil
        }
    }
}

extension Color {
    init(hex: String) {
        if let uiColor = UIColor(hex: hex) {
            self.init(uiColor)
        } else {
            self.init(.white)
        }
    }
    
    func toHex() -> String? {
        return UIColor(self).toHex()
    }
}

extension UIColor {
    func toHex() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(red * 255.0)
        let g = Int(green * 255.0)
        let b = Int(blue * 255.0)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

