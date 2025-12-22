//
//  ArithmeticFunctionLibrary.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class ArithmeticFunctionLibrary {

    func getFunctions() -> [String: ([Any]) throws -> Any] {
        return [
            "sum": sum,
            "subtract": subtract,
            "multiply": multiply,
            "divide": divide,
            "min": min,
            "max": max,
            "average": average,
            "formatNumber": formatNumber
        ]
    }

    private func sum(args: [Any]) throws -> Double {
        return args.reduce(0.0) { acc, val in
            acc + (Double("\(val)") ?? 0.0)
        }
    }

    private func subtract(args: [Any]) throws -> Double {
        guard args.count == 2 else {
            throw NSError(domain: "ArithmeticError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Subtract requires exactly 2 arguments."])
        }
        let first = Double("\(args[0])") ?? 0.0
        let second = Double("\(args[1])") ?? 0.0
        return first - second
    }

    private func multiply(args: [Any]) throws -> Double {
        return args.reduce(1.0) { acc, val in
            acc * (Double("\(val)") ?? 1.0)
        }
    }

    private func divide(args: [Any]) throws -> Double {
        guard args.count == 2 else {
            throw NSError(domain: "ArithmeticError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Divide requires exactly 2 arguments."])
        }
        let dividend = Double("\(args[0])") ?? 0.0
        let divisor = Double("\(args[1])") ?? 0.0
        if divisor == 0 {
            throw NSError(domain: "ArithmeticError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Cannot divide by zero."])
        }
        return dividend / divisor
    }

    private func min(args: [Any]) throws -> Double {
        return args.map { Double("\($0)") ?? 0.0 }.min() ?? 0.0
    }

    private func max(args: [Any]) throws -> Double {
        return args.map { Double("\($0)") ?? 0.0 }.max() ?? 0.0
    }

    private func average(args: [Any]) throws -> Double {
        guard !args.isEmpty else {
            throw NSError(domain: "ArithmeticError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Average requires at least 1 argument."])
        }
        let sumValue = try sum(args: args)
        return sumValue / Double(args.count)
    }

    private func formatNumber(args: [Any]) throws -> String {
        guard args.count == 2 else {
            throw NSError(domain: "ArithmeticError", code: 5, userInfo: [NSLocalizedDescriptionKey: "FormatNumber requires exactly 2 arguments."])
        }
        let number = args[0]
        let format = "\(args[1])"

        switch format {
        case "C":
            let formattedNumber = NumberFormatter()
            formattedNumber.numberStyle = .currency
            formattedNumber.currencyCode = "USD"
            return formattedNumber.string(from: NSNumber(value: Double("\(number)") ?? 0.0)) ?? ""
        case "P":
            let percentage = (Double("\(number)") ?? 0.0) * 100
            return String(format: "%.2f%%", percentage)
        default:
            throw NSError(domain: "ArithmeticError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Unsupported format."])
        }
    }
}

