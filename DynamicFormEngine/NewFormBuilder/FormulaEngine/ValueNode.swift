//
//  ValueNode.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class ValueNode: Node {
    private var value: Any

    init(value: Any) {
        self.value = value
        super.init()
    }

    func getValue() -> Any {
        return self.value
    }

    override func evaluate(variables: [String: Any]) -> Any {
        // If the value is a string and exists in the variables dictionary, return the variable's value
        if let stringValue = value as? String, let variableValue = variables[stringValue] {
            return variableValue
        }
        // Otherwise, return the literal value
        return self.value
    }
}
