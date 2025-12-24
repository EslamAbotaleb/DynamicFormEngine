//
//  FormValueCerqel.swift
//  DynamicFormEngine
//
//  Created by Eslam on 24/12/2025.
//

import Foundation

public protocol FormValueCerqel: Codable {}

extension String: FormValueCerqel {}
extension Bool: FormValueCerqel {}
