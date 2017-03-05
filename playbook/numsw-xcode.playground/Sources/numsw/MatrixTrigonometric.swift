//
//  MatrixTrigonometric.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import Accelerate

public func sin(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvsin(&result.elements, x.elements, [Int32(x.count)])
    return result
}

public func cos(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvcos(&result.elements, x.elements, [Int32(x.count)])
    return result
}

public func tan(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvtan(&result.elements, x.elements, [Int32(x.count)])
    return result
}

//public func atan2(_ x: Matrix) -> Matrix {
//    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
//    vvatan2(<#T##UnsafeMutablePointer<Double>#>, <#T##UnsafePointer<Double>#>, <#T##UnsafePointer<Double>#>, <#T##UnsafePointer<Int32>#>)(&result.elements, x.elements, [Int32(x.count)])
//    return result
//}
