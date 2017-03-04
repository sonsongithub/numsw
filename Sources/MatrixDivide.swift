import Accelerate

// scalar
public func /<T: FloatingPoint>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: lhs.elements.map { $0/rhs })
}

public func /<T: FloatingPoint>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return Matrix(rows: rhs.rows, columns: rhs.columns, elements: rhs.elements.map { lhs/$0 })
}
