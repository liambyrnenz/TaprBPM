//
//  UIFont+Custom.swift
//  UIFont+Custom
//
//  Created by Liam on 19/08/21.
//

import SwiftUI

extension Font {
    
    enum Custom: String {
        case ralewayRegular = "Raleway"
    }
    
    static func custom(_ name: Custom, size: CGFloat) -> Font {
        return self.custom(name.rawValue, size: size)
    }
    
}
