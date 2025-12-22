//
//  FunctionLibrary.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class FunctionLibrary {
    private var functions: [String: ([Any]) throws -> Any]

    init() {
        self.functions = [:]
        // Register functions from each category
        registerFunctions(ArithmeticFunctionLibrary().getFunctions())
        registerFunctions(DateTimeFunctionLibrary().getFunctions())
        registerFunctions(TextFunctionLibrary().getFunctions())
    }

    func registerFunction(name: String, fn: @escaping ([Any]) throws -> Any) {
        self.functions[name.lowercased()] = fn
    }

    func registerFunctions(_ functions: [String: ([Any]) throws -> Any]) {
        for (key, function) in functions {
            self.functions[key.lowercased()] = function
        }
    }

    func getFunction(name: String) throws -> ([Any]) throws -> Any {
        guard let fn = functions[name.lowercased()] else {
            throw NSError(domain: "FunctionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Function '\(name)' is not registered."])
        }
        return fn
    }
}
