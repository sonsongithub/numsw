
#if os(iOS) || os(OSX)
    
    public prefix func +<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_plus(arg)
    }
    
    public prefix func -<T: SignedNumber>(arg: NDArray<T>) -> NDArray<T> {
        return unary_minus(arg)
    }
    
    public func +<T: FloatingPoint>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return add(lhs, rhs)
    }
    
    public func -<T: FloatingPoint>(lhs: NDArray<T>, rhs: NDArray<T>) -> NDArray<T> {
        return subtract(lhs, rhs)
    }

#else
    
    // TODO: copy and paste naive implementation
    
#endif

private func unary_plus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    return NDArray(shape: arg.shape, elements: arg.elements.map{ +$0 })
}

private func unary_minus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    return NDArray(shape: arg.shape, elements: arg.elements.map{ -$0 })
}

private func add<T: FloatingPoint>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 + $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func subtract<T: FloatingPoint>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 - $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}
