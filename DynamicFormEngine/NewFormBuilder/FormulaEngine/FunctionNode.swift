//
//  FunctionNode.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class FunctionNode: Node {
    private var functionName: String
    private var arguments: [Node]
    private var functionLibrary: FunctionLibrary

    init(functionName: String, args: [Node], functionLibrary: FunctionLibrary) {
        self.functionName = functionName
        self.arguments = args
        self.functionLibrary = functionLibrary
        super.init()
    }

    func getArguments() -> [Node] {
        return self.arguments
    }

    override func evaluate(variables: [String: Any]) -> Any {
        // Evaluate each argument node to get its value
        let evaluatedArguments = arguments.map { $0.evaluate(variables: variables) }

        // Handle the case where the function retrieval can throw an error
        do {
            let function = try functionLibrary.getFunction(name: functionName)
            return try function(evaluatedArguments)
        } catch {
            fatalError("Function \(functionName) could not be executed: \(error.localizedDescription)")
        }
    }
}


