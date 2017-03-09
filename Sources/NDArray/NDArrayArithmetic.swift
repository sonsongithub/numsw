
#if os(iOS) || os(OSX)
    
    // TODO: rewrite with Accelerate
    
    public prefix func +<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_plus(arg)
    }
    
    public prefix func -<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_minus(arg)
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

private func unary_plus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    return NDArray(shape: arg.shape, elements: arg.elements.map{ +$0 })
}

private func unary_minus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    return NDArray(shape: arg.shape, elements: arg.elements.map{ -$0 })
}

private func add<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 + $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func subtract<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 - $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func multiply<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 * $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func divide<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 / $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func modulo<T: Moduloable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 % $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}
