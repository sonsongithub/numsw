//import Accelerate
//
//// scalar
//public func /(lhs: Matrix, rhs: Double) -> Matrix {
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: lhs.elements.map { $0/rhs })
//}
//
//public func /(lhs: Double, rhs: Matrix) -> Matrix {
//    return Matrix(rows: rhs.rows, columns: rhs.columns, elements: rhs.elements.map { lhs/$0 })
//}
//
//public func /=(lhs: inout Matrix, rhs: Double) {
//    lhs = lhs / rhs
//}
