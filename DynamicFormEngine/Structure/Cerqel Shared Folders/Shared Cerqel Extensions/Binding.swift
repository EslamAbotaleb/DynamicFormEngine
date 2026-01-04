//
//  Binding.swift
//  CERQEL
//
//  Created by Youxel on 25/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import SwiftUI

extension Binding {
   public func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
