//
//  DynamicArray+Extensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 17/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import Foundation


extension Array where Element == String {
    
    mutating func appendIfNotContain(_ element: String) {
        if !contains(element) {
            append(element)
        }
    }
    
}

extension Array where Element == FieldValidationType {
    
    mutating func appendIfNotContain(_ element: FieldValidationType) {
        if !contains(element) {
            append(element)
        }
    }
    
}

