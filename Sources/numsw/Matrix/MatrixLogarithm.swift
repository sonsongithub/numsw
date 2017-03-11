//
//  MatrixLogarithm.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import Accelerate

public func exp(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvexp(&result.elements, x.elements, [Int32(x.count)])
    return result
}

public func exp2(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvexp2(&result.elements, x.elements, [Int32(x.count)])
    return result
}

public func log(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvlog(&result.elements, x.elements, [Int32(x.count)])
    return result
}

public func log10(_ x: Matrix) -> Matrix {
    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
    vvlog10(&result.elements, x.elements, [Int32(x.count)])
    return result
}

//public func logb(_ x: Matrix) -> Matrix {
//    var result = Matrix.zeros(rows: x.rows, columns: x.columns)
//    vvlogb(&result.elements, x.elements, [Int32(x.count)])
//    return result
//}
