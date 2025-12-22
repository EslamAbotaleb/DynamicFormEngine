//
//  TextFunctionLibrary.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class TextFunctionLibrary {

    func getFunctions() -> [String: ([Any]) throws -> Any] {
        return [
            "concatenate": concatenate,
            "toUpper": toUpper,
            "toLower": toLower,
            "substring": substring,
            "length": length,
            "replace": replace,
            "trim": trim,
            "contains": contains,
            "minText": minText,
            "maxText": maxText
        ]
    }

    private func concatenate(args: [Any]) throws -> String {
        return args.compactMap { "\($0)" }.joined()
    }

    private func toUpper(args: [Any]) throws -> String {
        guard args.count == 1 else {
            throw NSError(domain: "TextFunctionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "ToUpper requires exactly 1 argument."])
        }
        return "\(args[0])".uppercased()
    }

    private func toLower(args: [Any]) throws -> String {
        guard args.count == 1 else {
            throw NSError(domain: "TextFunctionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "ToLower requires exactly 1 argument."])
        }
        return "\(args[0])".lowercased()
    }

    private func substring(args: [Any]) throws -> String {
        guard args.count == 3, let text = args[0] as? String, let startIndex = args[1] as? Int, let length = args[2] as? Int else {
            throw NSError(domain: "TextFunctionError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Substring requires exactly 3 arguments."])
        }
        let start = text.index(text.startIndex, offsetBy: startIndex)
        let end = text.index(start, offsetBy: length, limitedBy: text.endIndex) ?? text.endIndex
        return String(text[start..<end])
    }

    private func length(args: [Any]) throws -> Int {
        guard args.count == 1 else {
            throw NSError(domain: "TextFunctionError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Length requires exactly 1 argument."])
        }
        return "\(args[0])".count
    }

    private func replace(args: [Any]) throws -> String {
        guard args.count == 3, let text = args[0] as? String, let searchText = args[1] as? String, let replaceText = args[2] as? String else {
            throw NSError(domain: "TextFunctionError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Replace requires exactly 3 arguments."])
        }
        return text.replacingOccurrences(of: searchText, with: replaceText)
    }

    private func trim(args: [Any]) throws -> String {
        guard args.count == 1 else {
            throw NSError(domain: "TextFunctionError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Trim requires exactly 1 argument."])
        }
        return "\(args[0])".trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func contains(args: [Any]) throws -> Bool {
        guard args.count == 2, let text = args[0] as? String, let searchText = args[1] as? String else {
            throw NSError(domain: "TextFunctionError", code: 7, userInfo: [NSLocalizedDescriptionKey: "Contains requires exactly 2 arguments."])
        }
        return text.contains(searchText)
    }

    private func minText(args: [Any]) throws -> String {
        return args.compactMap { "\($0)" }.min() ?? ""
    }

    private func maxText(args: [Any]) throws -> String {
        return args.compactMap { "\($0)" }.max() ?? ""
    }
}

