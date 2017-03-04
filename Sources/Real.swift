
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


public protocol RealDouble {
    var value: Double { get }
}

extension Double: RealDouble {
    public var value: Double {
        get {
            return self
        }
    }
}

public protocol RealFloat {
    var value: Float { get }
}

extension Float: RealFloat {
    public var value: Float {
        get {
            return self
        }
    }
}
