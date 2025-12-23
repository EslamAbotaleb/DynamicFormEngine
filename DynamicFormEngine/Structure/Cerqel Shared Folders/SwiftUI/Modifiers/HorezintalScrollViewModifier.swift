//
//  HorezintalScrollViewModifier.swift
//  CERQEL
//
//  Created by Youxel on 31/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import SwiftUI

public struct ReverseScrollViewModifier: ViewModifier {
    let layoutDirection: LayoutDirection

    public func body(content: Content) -> some View {
        content
            .offset(x: layoutDirection == .rightToLeft ? UIScreen.main.bounds.width : 0)
    }
}
