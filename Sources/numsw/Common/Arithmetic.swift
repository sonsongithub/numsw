
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
