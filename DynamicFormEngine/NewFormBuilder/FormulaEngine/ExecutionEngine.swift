//
//  ExecutionEngine.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class ExecutionEngine {
    private var functionLibrary: FunctionLibrary

    init(functionLibrary: FunctionLibrary) {
        self.functionLibrary = functionLibrary
    }

    func execute(expression: Node, variables: [String: Any]) -> Any {
        // The expression (AST root) is evaluated, which will recursively evaluate all child nodes
        return expression.evaluate(variables: variables)
    }
}


