// MARK: - Scalar
public func +=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: T) {
    lhs = lhs + rhs
}

public func -=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: T) {
    lhs = lhs - rhs
}

public func *=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: T) {
    lhs = lhs * rhs
}

public func /=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: T) {
    lhs = lhs / rhs
}

public func %=<T: Moduloable>(lhs: inout Matrix<T>, rhs: T) {
    lhs = lhs % rhs
}

// MARK: - Matrix
public func +=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs + rhs
}

public func -=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs - rhs
}

public func *=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs * rhs
}

public func .*=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs .* rhs
}

public func /=<T: Arithmetic>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs / rhs
}

public func %=<T: Moduloable>(lhs: inout Matrix<T>, rhs: Matrix<T>) {
    lhs = lhs % rhs
}
