infix operator .*
infix operator .*=

func apply<T, R>(_ arg: Matrix<T>, _ handler: (T) -> R) -> Matrix<R> {
    return Matrix(rows: arg.rows,
                  columns: arg.columns,
                  elements: apply(arg.elements, handler))
}

func combine<T, U, R>(_ lhs: Matrix<T>, _ rhs: Matrix<U>, _ handler: (T, U) -> R) -> Matrix<R> {
    precondition(lhs.rows==rhs.rows && lhs.columns == rhs.columns, "Two matrices have incompatible shape.")
    
    return Matrix(rows: lhs.rows,
                  columns: lhs.columns,
                  elements: combine(lhs.elements, rhs.elements, handler))
}
