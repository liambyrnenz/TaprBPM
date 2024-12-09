//
//  FloatingPoint+Range.swift
//  FloatingPoint+Range
//
//  Created by Liam on 18/08/21.
//

import Foundation

extension FloatingPoint {

    func clamped(between lowest: Self, and highest: Self) -> Self {
        return min(max(self, lowest), highest)
    }

    func percentage(between lowest: Self, and highest: Self) -> Self {
        return ((self - lowest) / (highest - lowest)).clamped(between: 0, and: 1)
    }

}
