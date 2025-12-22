//
//  FormulaEngine.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class FormulaEngine {
    private var validator: Validator
    private var parser: ExpressionParser
    private var functionLibrary: FunctionLibrary
    private var executionEngine: ExecutionEngine

    init() {
        self.functionLibrary = FunctionLibrary()
        self.parser = ExpressionParser(functionLibrary: self.functionLibrary)
        self.validator = Validator(expressionParser: self.parser)
        self.executionEngine = ExecutionEngine(functionLibrary: self.functionLibrary)
    }

    func evaluate(formula: String, variables: [String: Any]) throws -> Any {
        // Validate the formula first
        let validationResult = validator.validate(formula: formula)
        if !validationResult.isValid {
            throw NSError(domain: "FormulaError", code: 1, userInfo: [NSLocalizedDescriptionKey: validationResult.errorMessage])
        }

        // Parse the formula into an AST
        let expression: Node = parser.parse(formula)

        // Execute the parsed expression
        return executionEngine.execute(expression: expression, variables: variables)
    }
}
