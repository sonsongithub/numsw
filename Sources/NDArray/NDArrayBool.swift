
// operators
public prefix func !(arg: NDArray<Bool>) -> NDArray<Bool> {
    return not(arg)
}
public func &&(lhs: NDArray<Bool>, rhs: NDArray<Bool>) -> NDArray<Bool> {
    return and(lhs, rhs)
}
public func ||(lhs: NDArray<Bool>, rhs: NDArray<Bool>) -> NDArray<Bool> {
    return and(lhs, rhs)
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


// NDArray<Bool>
private func not(_ arg: NDArray<Bool>) -> NDArray<Bool> {
    return NDArray(shape: arg.shape, elements: arg.elements.map(!))
}

private func and(_ lhs: NDArray<Bool>, _ rhs: NDArray<Bool>) -> NDArray<Bool> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 && $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}

private func or(_ lhs: NDArray<Bool>, _ rhs: NDArray<Bool>) -> NDArray<Bool> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    
    let elements = zip(lhs.elements, rhs.elements).map { $0 || $1 }
    
    return NDArray(shape: lhs.shape, elements: elements)
}


// NDArray and scalar
private func equal<T: Equatable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    return NDArray(shape: lhs.shape, elements: lhs.elements.map { $0 == rhs })
}

private func lessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    return NDArray(shape: lhs.shape, elements: lhs.elements.map { $0 < rhs })
}

private func greaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    return NDArray(shape: lhs.shape, elements: lhs.elements.map { $0 > rhs })
}

private func notGreaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    return NDArray(shape: lhs.shape, elements: lhs.elements.map { $0 <= rhs })
}

private func notLessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<Bool> {
    return NDArray(shape: lhs.shape, elements: lhs.elements.map { $0 >= rhs })
}


// NDArray and NDArray
private func equal<T: Equatable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    return NDArray(shape: lhs.shape, elements: zip(lhs.elements, rhs.elements).map { $0 == $1 })
}

private func lessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    return NDArray(shape: lhs.shape, elements: zip(lhs.elements, rhs.elements).map { $0 < $1 })
}

private func greaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    return NDArray(shape: lhs.shape, elements: zip(lhs.elements, rhs.elements).map { $0 > $1 })
}

private func notGreaterThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    return NDArray(shape: lhs.shape, elements: zip(lhs.elements, rhs.elements).map { $0 <= $1 })
}

private func notLessThan<T: Comparable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<Bool> {
    precondition(lhs.shape == rhs.shape, "")
    return NDArray(shape: lhs.shape, elements: zip(lhs.elements, rhs.elements).map { $0 >= $1 })
}
