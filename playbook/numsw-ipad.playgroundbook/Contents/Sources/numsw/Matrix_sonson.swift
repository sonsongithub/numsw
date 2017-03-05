//
//  Matrix_sonson.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import Foundation

extension Matrix {
    public var count: Int {
        return columns * rows
    }
    
    public func show() {
        var string = ""
        for i in 0..<rows {
            for j in 0..<columns {
                string.append("\(elements[j + i * columns]) ")
            }
            if i < rows - 1 {
                string.append("\n")
            }
        }
        print(string)
    }
}

public func frobeniusNorm(_ hs: Matrix) -> Double {
    return hs.elements.reduce(0) { (result, value) -> Double in
        return result + value * value
    }
}
