//
//  CustomError.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

struct cerqel_CustomError: LocalizedError {
    let value: String
    var localizedDescription: String {
        return value
    }
    
}
