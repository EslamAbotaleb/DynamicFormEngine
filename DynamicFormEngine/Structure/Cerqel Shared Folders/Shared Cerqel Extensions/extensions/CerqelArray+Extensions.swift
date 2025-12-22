//
//  Array+Extensions.swift
//  CERQEL
//
//  Created by Marwan on 07/02/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation


extension Array where Element == String {
    
    mutating func cerqel_appendIfNotContain(_ element: String) {
        if !contains(element) {
            append(element)
        }
    }
    
}

extension Array where Element == FieldValidationType {
    
    mutating func cerqel_appendIfNotContain(_ element: FieldValidationType) {
        if !contains(element) {
            append(element)
        }
    }
    
}
