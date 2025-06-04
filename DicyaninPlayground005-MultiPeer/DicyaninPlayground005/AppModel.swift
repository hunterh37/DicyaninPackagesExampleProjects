//
//  AppModel.swift
//  DicyaninPlayground005
//
//  Created by Hunter Harris on 5/30/25.
//

import SwiftUI
import DicyaninMultiPeer

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    
    var manager = MultiDeviceManager(displayName: "DicyaninPlayground005-visionOS")
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
