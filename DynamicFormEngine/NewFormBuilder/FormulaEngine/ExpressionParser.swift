//
//  ExpressionParser.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class ExpressionParser {
    private var functionLibrary: FunctionLibrary

    init(functionLibrary: FunctionLibrary) {
        self.functionLibrary = functionLibrary
    }

    func parse(_ formula: String) -> Node {
        var cleanedFormula = formula.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "'", with: "\"")

        if isFunctionCall(cleanedFormula) {
            return parseFunction(formula: cleanedFormula)
        }

        return parseValue(cleanedFormula)
    }

    private func isFunctionCall(_ formula: String) -> Bool {
        return formula.contains("(") && formula.hasSuffix(")")
    }

    private func parseFunction(formula: String) -> FunctionNode {
        let regex = try! NSRegularExpression(pattern: "(\\w+)\\((.*)\\)", options: [])
        guard let match = regex.firstMatch(in: formula, range: NSRange(location: 0, length: formula.utf16.count)) else {
            fatalError("Invalid function format.")
        }

        let functionName = (formula as NSString).substring(with: match.range(at: 1))
        let argumentsString = (formula as NSString).substring(with: match.range(at: 2))

        let argumentNodes = parseArguments(argumentsString: argumentsString)
        return FunctionNode(functionName: functionName, args: argumentNodes, functionLibrary: functionLibrary)
    }

    private func parseArguments(argumentsString: String) -> [Node] {
        var nodes = [Node]()
        var bracketDepth = 0
        var insideString = false
        var stringDelimiter: Character?
        var startIndex = argumentsString.startIndex

        for (index, char) in argumentsString.enumerated() {
            switch char {
            case "(":
                bracketDepth += 1
            case ")":
                bracketDepth -= 1
            case "\"", "'":
                if insideString && char == stringDelimiter {
                    insideString = false
                } else if !insideString {
                    insideString = true
                    stringDelimiter = char
                }
            case ",":
                if bracketDepth == 0 && !insideString {
                    let endIndex = argumentsString.index(argumentsString.startIndex, offsetBy: index)
                    nodes.append(parse(String(argumentsString[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)))
                    startIndex = argumentsString.index(after: endIndex)
                }
            default:
                continue
            }
        }

        let endIndex = argumentsString.endIndex
        nodes.append(parse(String(argumentsString[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)))

        return nodes
    }

    private func parseValue(_ value: String) -> Node {
        if let number = Double(value) {
            return ValueNode(value: number)
        }

        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: value) {
            return ValueNode(value: date)
        }

        return ValueNode(value: value.replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression))
    }
}
