
// Scalar
public func +=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: T) {
    lhs = lhs + rhs
}

public func -=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: T) {
    lhs = lhs - rhs
}

public func *=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: T) {
    lhs = lhs * rhs
}

public func /=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: T) {
    lhs = lhs / rhs
}

public func %=<T: Moduloable>(lhs: inout NDArray<T>, rhs: T) {
    lhs = lhs % rhs
}

// NDArray
public func +=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: NDArray<T>) {
    lhs = lhs + rhs
}

public func -=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: NDArray<T>) {
    lhs = lhs - rhs
}

public func *=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: NDArray<T>) {
    lhs = lhs * rhs
}

public func /=<T: Arithmetic>(lhs: inout NDArray<T>, rhs: NDArray<T>) {
    lhs = lhs / rhs
}

public func %=<T: Moduloable>(lhs: inout NDArray<T>, rhs: NDArray<T>) {
    lhs = lhs % rhs
}
