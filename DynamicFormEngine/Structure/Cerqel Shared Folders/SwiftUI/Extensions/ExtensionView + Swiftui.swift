////
////  ExtensionView + Swiftui.swift
////  CERQEL
////
////  Created by Muhammed Sabri on 14/01/2024.
////  Copyright © 2024 Youxel. All rights reserved.
////
//
import Foundation
import SwiftUI

extension View {
    public func dismissingGesture(tolerance: Double = 24, direction: DragGesture.Value.Direction, action: @escaping () -> ()) -> some View {
        gesture(DragGesture()
            .onEnded { value in
                let swipeDirection = value.detectDirection(tolerance)
                if swipeDirection == direction {
                    action()
                }
            }
        )
    }
}

extension DragGesture.Value {
    public func detectDirection(_ tolerance: Double = 24) -> Direction? {
        if startLocation.x < location.x - tolerance { return .left }
        if startLocation.x > location.x + tolerance { return .right }
        if startLocation.y > location.y + tolerance { return .up }
        if startLocation.y < location.y - tolerance { return .down }
        return nil
    }

    public enum Direction {
        case left
        case right
        case up
        case down
    }
}

extension UIView {
    public func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.LightGrey.cgColor
        layer.shadowOffset = CGSize(width: 1 , height: 3)
    }
}
