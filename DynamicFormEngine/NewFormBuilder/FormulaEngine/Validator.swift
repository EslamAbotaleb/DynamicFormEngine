//
//  Validator.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

struct ValidationResult {
    var isValid: Bool
    var errorMessage: String?
}

class Validator {
    private var expressionParser: ExpressionParser

    init(expressionParser: ExpressionParser) {
        self.expressionParser = expressionParser
    }

    func validate(formula: String) -> ValidationResult {
        if formula.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return ValidationResult(isValid: false, errorMessage: "Formula cannot be empty.")
        }

        if !areParenthesesBalanced(formula: formula) {
            return ValidationResult(isValid: false, errorMessage: "Parentheses are not balanced.")
        }

        do {
            let rootNode = try expressionParser.parse(formula)
            return validateFormats(rootNode: rootNode)
        } catch let error {
            return ValidationResult(isValid: false, errorMessage: error.localizedDescription)
        }
    }

    private func validateFormats(rootNode: Node) -> ValidationResult {
        if let functionNode = rootNode as? FunctionNode {
            for arg in functionNode.getArguments() {
                if let valueNode = arg as? ValueNode {
                    let value = valueNode.getValue()

                    if let number = value as? Double, number.isNaN {
                        return ValidationResult(isValid: false, errorMessage: "Invalid number format.")
                    }

                    if let date = value as? Date, date.timeIntervalSince1970.isNaN {
                        return ValidationResult(isValid: false, errorMessage: "Invalid date format. Expected format: yyyy-MM-dd")
                    }

                    if let stringValue = value as? String, stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        return ValidationResult(isValid: false, errorMessage: "Invalid string format.")
                    }
                }
            }
        }

        return ValidationResult(isValid: true, errorMessage: nil)
    }

    private func areParenthesesBalanced(formula: String) -> Bool {
        var balance = 0
        for char in formula {
            if char == "(" { balance += 1 }
            if char == ")" { balance -= 1 }

            if balance < 0 { return false }
        }
        return balance == 0
    }
}
