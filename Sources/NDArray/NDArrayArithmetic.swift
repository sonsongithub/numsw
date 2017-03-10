
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
    return apply(arg, +)
}

func unary_minus<T: SignedNumber>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, -)
}


// NDArray and scalar
func add<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    return apply(lhs) { $0 + rhs }
}

func add<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    return apply(rhs) { lhs + $0 }
}

func subtract<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    return apply(lhs) { $0 - rhs }
}

func subtract<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    return apply(rhs) { lhs - $0 }}

func multiply<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    return apply(lhs) { $0 * rhs }
}

func multiply<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    return apply(rhs) { lhs * $0 }
}

func divide<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    return apply(lhs) { $0 / rhs }
}

func divide<T: Arithmetic>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    return apply(rhs) { lhs / $0 }
}

func modulo<T: Moduloable>(_ lhs: NDArray<T>, _ rhs: T) -> NDArray<T> {
    return apply(lhs) { $0 % rhs }
}

func modulo<T: Moduloable>(_ lhs: T, _ rhs: NDArray<T>) -> NDArray<T> {
    return apply(rhs) { lhs % $0 }
}


// NDArray and NDArray
func add<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    return combine(lhs, rhs, +)
}

func subtract<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    return combine(lhs, rhs, -)
}

func multiply<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    return combine(lhs, rhs, *)
}

func divide<T: Arithmetic>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    return combine(lhs, rhs, /)
}

func modulo<T: Moduloable>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) -> NDArray<T> {
    return combine(lhs, rhs, %)
}
