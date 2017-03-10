
func apply<T, R>(_ arg: NDArray<T>, _ handler: (T)->R) -> NDArray<R> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<R>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = handler(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func combine<T, U, R>(_ lhs: NDArray<T>, _ rhs: NDArray<U>, _ handler: (T, U) -> R) -> NDArray<R> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
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
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}
