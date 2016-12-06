/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Configuration information and parameters for the game's gameplay. Adjust these numbers to modify how the game behaves.
*/

import Foundation
import CoreGraphics

struct GameplayConfiguration {
    
    struct TouchControl {
        /// The minimum distance a virtual thumbstick must move before it is considered to have been moved.
        static let minimumRequiredThumbstickDisplacement: Float = 0.35
        
        /// The minimum size for an on-screen control.
        static let minimumControlSize: CGFloat = 140
        
        /// The ideal size for an on-screen control as a ratio of the scene's width.
        static let idealRelativeControlSize: CGFloat = 0.15
    }
    
    struct SceneManager {
        /// The duration of a transition between loaded scenes.
        static let transitionDuration: TimeInterval = 2.0
        
        /// The duration of a transition from the progress scene to its loaded scene.
        static let progressSceneTransitionDuration: TimeInterval = 0.5
    }
    
    struct Timer {
        /// The name of the font to use for the timer.
        static let fontName = "DINCondensed-Bold"
        
        /// The size of the timer node font as a proportion of the level scene's height.
        static let fontSize: CGFloat = 0.05
        
        #if os(tvOS)
        /// The size of padding between the top of the scene and the timer node.
        static let paddingSize: CGFloat = 60.0
        #else
        /// The size of padding between the top of the scene and the timer node as a proportion of the timer node's font size.
        static let paddingSize: CGFloat = 0.2
        #endif
    }
}
