//
//  DynamicHeightModifier.swift
//  CERQEL
//
//  Created by ahmed maher on 05/11/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import SwiftUI

public struct CalculateHeight: ViewModifier {
    @Binding var height: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                height = proxy.size.height
                            }
                        }
                        .onChange(of: proxy.size.height) { newHeight in
                            DispatchQueue.main.async {
                                height = newHeight
                            }
                        }
                }
            )
    }
}
