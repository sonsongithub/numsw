
// operators
public prefix func !(arg: NDArray<Bool>) -> NDArray<Bool> {
    return not(arg)
}
public func &&(lhs: NDArray<Bool>, rhs: NDArray<Bool>) -> NDArray<Bool> {
    return and(lhs, rhs)
}
public func ||(lhs: NDArray<Bool>, rhs: NDArray<Bool>) -> NDArray<Bool> {
    return or(lhs, rhs)
}

public func ==<T: Equatable>(lhs: NDArray<T>, rhs: T) -> NDArray<Bool> {
    return equal(lhs, rhs)
}
public func ==<T: Equatable>(lhs: T, rhs: NDArray<T>) -> NDArray<Bool> {
    return equal(rhs, lhs)
}
public func <<T: Comparable>(lhs: NDArray<T>, rhs: T) -> NDArray<Bool> {
    return lessThan(lhs, rhs)
}
public func <<T: Comparable>(lhs: T, rhs: NDArray<T>) -> NDArray<Bool> {
    return greaterThan(rhs, lhs)
}
public func ><T: Comparable>(lhs: NDArray<T>, rhs: T) -> NDArray<Bool> {
    return greaterThan(lhs, rhs)
}
public func ><T: Comparable>(lhs: T, rhs: NDArray<T>) -> NDArray<Bool> {
    return lessThan(rhs, lhs)
}
public func <=<T: Comparable>(lhs: NDArray<T>, rhs: T) -> NDArray<Bool> {
    return notGreaterThan(lhs, rhs)
}
public func <=<T: Comparable>(lhs: T, rhs: NDArray<T>) -> NDArray<Bool> {
    return notLessThan(rhs, lhs)
}
public func >=<T: Comparable>(lhs: NDArray<T>, rhs: T) -> NDArray<Bool> {
    return notLessThan(lhs, rhs)
}
public func >=<T: Comparable>(lhs: T, rhs: NDArray<T>) -> NDArray<Bool> {
    return notGreaterThan(rhs, lhs)
}

public func ==<T: Equatable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<Bool> {
    return equal(lhs, rhs)
}
public func <<T: Comparable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<Bool> {
    return lessThan(lhs, rhs)
}
public func ><T: Comparable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<Bool> {
    return greaterThan(lhs, rhs)
}
public func <=<T: Comparable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<Bool> {
    return notGreaterThan(lhs, rhs)
}
public func >=<T: Comparable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<Bool> {
    return notLessThan(lhs, rhs)
}


// unary
func not(_ arg: NDArray<Bool>) -> NDArray<Bool> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = !inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))

}

// binary
func and(_ lhs: NDArray<Bool>, _ rhs: NDArray<Bool>) -> NDArray<Bool> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee && rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))

}

func or(_ lhs: NDArray<Bool>, _ rhs: NDArray<Bool>) -> NDArray<Bool> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee || rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}


// NDArray and scalar
func equal<T: Equatable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee == rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func lessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee < rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func greaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee > rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func notGreaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee <= rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func notLessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee >= rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}


// NDArray and NDArray
func equal<T: Equatable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee == rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func lessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee < rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func greaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee > rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func notGreaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee <= rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func notLessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    
    var lhsPointer = UnsafePointer(lhs.elements)
    var rhsPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<Bool>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhsPointer.pointee >= rhsPointer.pointee
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}
