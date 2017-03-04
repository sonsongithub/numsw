
public protocol Real {
    static func * (lhs: Self, rhs: Self) -> Self
}

extension Float : Real {
    
}

extension Double : Real {
    
}

public func +<T: Real> (_ x: T, _ y: T) -> T {
    return x + y
}

public func -<T: Real> (_ x: T, _ y: T) -> T {
    return x - y
}

public func *<T: Real> (_ x: T, _ y: T) -> T {
    return x * y
}

public func /<T: Real> (_ x: T, _ y: T) -> T {
    return x / y
}
