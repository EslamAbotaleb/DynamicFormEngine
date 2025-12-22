//
//  Node.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class Node {
    // Abstract method that must be implemented by subclasses
    func evaluate(variables: [String: Any]) -> Any {
        fatalError("Subclasses must implement the evaluate method")
    }
}

