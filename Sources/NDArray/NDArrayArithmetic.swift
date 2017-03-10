
#if os(iOS) || os(OSX) || true // TODO: remove true
    
    // TODO: rewrite with Accelerate
    
    public prefix func +<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_plus(arg)
    }
    
    public prefix func -<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_minus(arg)
    }
    
    public func +<T: Arithmetic>(lhs: NDArray<T>, rhs: T) -> NDArray<T> {
        return add(lhs, rhs)
    }
    
    public func -<T: Arithmetic>(lhs: NDArray<T>, rhs: T) -> NDArray<T> {
        return subtract(lhs, rhs)
    }
    
    public func *<T: Arithmetic>(lhs: NDArray<T>, rhs: T) -> NDArray<T> {
        return multiply(lhs, rhs)
    }
    
    public func /<T: Arithmetic>(lhs: NDArray<T>, rhs: T) -> NDArray<T> {
        return divide(lhs, rhs)
    }
    
    public func %<T: Moduloable>(lhs: NDArray<T>, rhs: T) -> NDArray<T> {
        return modulo(lhs, rhs)
    }
    
    public func +<T: Arithmetic>(lhs: T, rhs: NDArray<T>) -> NDArray<T> {
        return add(lhs, rhs)
    }
    
    public func -<T: Arithmetic>(lhs: T, rhs: NDArray<T>) -> NDArray<T> {
        return subtract(lhs, rhs)
    }
    
    public func *<T: Arithmetic>(lhs: T, rhs: NDArray<T>) -> NDArray<T> {
        return multiply(lhs, rhs)
    }
    
    public func /<T: Arithmetic>(lhs: T, rhs: NDArray<T>) -> NDArray<T> {
        return divide(lhs, rhs)
    }
    
    public func %<T: Moduloable>(lhs: T, rhs: NDArray<T>) -> NDArray<T> {
        return modulo(lhs, rhs)
    }
    
    public func +<T: Arithmetic>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return add(lhs, rhs)
    }
    
    public func -<T: Arithmetic>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return subtract(lhs, rhs)
    }
    
    public func *<T: Arithmetic>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return multiply(lhs, rhs)
    }
    
    public func /<T: Arithmetic>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return divide(lhs, rhs)
    }
    
    public func %<T: Moduloable>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return modulo(lhs, rhs)
    }

#else
    
    // TODO: copy and paste naive implementation
    
#endif

public protocol Arithmetic {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
}

public protocol Moduloable {
    static func %(lhs: Self, rhs: Self) -> Self
}


extension Int: Arithmetic, Moduloable {}
extension UInt: Arithmetic, Moduloable {}
extension Float: Arithmetic {}
extension Double: Arithmetic {}


// unary
func unary_plus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = +inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func unary_minus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = -inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}


// NDArray and scalar
func add<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee + rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func add<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
    defer { outPointer.deallocate(capacity: rhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhs + inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: rhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: rhs.elements.count)))
}

func subtract<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee - rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func subtract<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
    defer { outPointer.deallocate(capacity: rhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhs - inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: rhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: rhs.elements.count)))
}

func multiply<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee * rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func multiply<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
    defer { outPointer.deallocate(capacity: rhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhs * inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: rhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: rhs.elements.count)))
}

func divide<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee / rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func divide<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
    defer { outPointer.deallocate(capacity: rhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhs / inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: rhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: rhs.elements.count)))}

func modulo<T: Moduloable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    var inPointer = UnsafePointer(lhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
    defer { outPointer.deallocate(capacity: lhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<lhs.elements.count {
        p.pointee = inPointer.pointee % rhs
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: lhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: lhs.elements.count)))
}

func modulo<T: Moduloable>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(rhs.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
    defer { outPointer.deallocate(capacity: rhs.elements.count) }
    
    var p = outPointer
    for _ in 0..<rhs.elements.count {
        p.pointee = lhs % inPointer.pointee
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: rhs.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: rhs.elements.count)))
}


// NDArray and NDArray
func add<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 + $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

func subtract<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 - $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

func multiply<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 * $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

func divide<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 / $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

func modulo<T: Moduloable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 % $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}
