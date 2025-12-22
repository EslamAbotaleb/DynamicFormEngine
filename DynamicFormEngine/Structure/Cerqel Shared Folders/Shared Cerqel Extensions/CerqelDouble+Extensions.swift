//
//  Double+Extensions.swift
//  CERQEL
//
//  Created by Marwan on 20/02/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

extension Double {
    
    var cerqel_clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
}
