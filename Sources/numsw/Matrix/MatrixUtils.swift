
infix operator .*

func apply<T, R>(_ arg: Matrix<T>, _ handler: (T)->R) -> Matrix<R> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<R>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = handler(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return Matrix(rows: arg.rows,
                  columns: arg.columns,
                  elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func combine<T, U, R>(_ lhs: Matrix<T>, _ rhs: Matrix<U>, _ handler: (T, U) -> R) -> Matrix<R> {
    precondition(lhs.rows==rhs.rows && lhs.columns == rhs.columns, "Two matrices have incompatible shape.")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<R>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = handler(lhsPointer.pointee, rhsPointer.pointee)
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return Matrix(rows: lhs.rows,
                  columns: lhs.columns,
                  elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}
