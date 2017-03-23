
// MARK: - Unary
public prefix func +<T: SignedNumber>(arg: Matrix<T>) -> Matrix<T> {
    return unaryPlus(arg)
}

public prefix func -<T: SignedNumber>(arg: Matrix<T>) -> Matrix<T> {
    return unaryMinus(arg)
}

public func +<T: Arithmetic>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return add(lhs, rhs)
}

public func -<T: Arithmetic>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return subtract(lhs, rhs)
}

// MARK: - Matrix and scalar
public func *<T: Arithmetic>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return multiply(lhs, rhs)
}

public func /<T: Arithmetic>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return divide(lhs, rhs)
}

public func %<T: Moduloable>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return modulo(lhs, rhs)
}

public func +<T: Arithmetic>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return add(lhs, rhs)
}

public func -<T: Arithmetic>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return subtract(lhs, rhs)
}

public func *<T: Arithmetic>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return multiply(lhs, rhs)
}

public func /<T: Arithmetic>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return divide(lhs, rhs)
}

public func %<T: Moduloable>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return modulo(lhs, rhs)
}

// MARK: - Matrix and Matrix
public func +<T: Arithmetic>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return add(lhs, rhs)
}

public func -<T: Arithmetic>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return subtract(lhs, rhs)
}

public func .*<T: Arithmetic>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return elementWiseProduct(lhs, rhs)
}

public func /<T: Arithmetic>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return divide(lhs, rhs)
}

public func %<T: Moduloable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return modulo(lhs, rhs)
}


// MARK: - Unary
func unaryPlus<T: SignedNumber>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, +)
}

func unaryMinus<T: SignedNumber>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, -)
}


// MARK: - Matrix and scalar
func add<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: T) -> Matrix<T> {
    return apply(lhs) { $0 + rhs }
}

func add<T: Arithmetic>(_ lhs: T, _ rhs: Matrix<T>) -> Matrix<T> {
    return apply(rhs) { lhs + $0 }
}

func subtract<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: T) -> Matrix<T> {
    return apply(lhs) { $0 - rhs }
}

func subtract<T: Arithmetic>(_ lhs: T, _ rhs: Matrix<T>) -> Matrix<T> {
    return apply(rhs) { lhs - $0 }}

func multiply<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: T) -> Matrix<T> {
    return apply(lhs) { $0 * rhs }
}

func multiply<T: Arithmetic>(_ lhs: T, _ rhs: Matrix<T>) -> Matrix<T> {
    return apply(rhs) { lhs * $0 }
}

func divide<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: T) -> Matrix<T> {
    return apply(lhs) { $0 / rhs }
}

func divide<T: Arithmetic>(_ lhs: T, _ rhs: Matrix<T>) -> Matrix<T> {
    return apply(rhs) { lhs / $0 }
}

func modulo<T: Moduloable>(_ lhs: Matrix<T>, _ rhs: T) -> Matrix<T> {
    return apply(lhs) { $0 % rhs }
}

func modulo<T: Moduloable>(_ lhs: T, _ rhs: Matrix<T>) -> Matrix<T> {
    return apply(rhs) { lhs % $0 }
}


// MARK: - Matrix and Matrix
func add<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return combine(lhs, rhs, +)
}

func subtract<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return combine(lhs, rhs, -)
}

func elementWiseProduct<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return combine(lhs, rhs, *)
}

func divide<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return combine(lhs, rhs, /)
}

func modulo<T: Moduloable>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return combine(lhs, rhs, %)
}
