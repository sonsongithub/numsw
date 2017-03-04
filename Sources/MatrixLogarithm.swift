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
