//
//  ValidatableCell.swift
//  CERQEL
//
//  Created by hassan elshaer on 07/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation
import UIKit

protocol ValidatableCell {
    func displayValidationError(_ message: String)
    func clearValidationError()
}

