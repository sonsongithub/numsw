public protocol ZeroOne {
    static var zero: Self { get }
    static var one: Self { get }
}

extension Int: ZeroOne {
    public static var zero: Int {
        return 0
    }
    public static var one: Int {
        return 1
    }
}

extension UInt: ZeroOne {
    public static var zero: UInt {
        return 0
    }
    public static var one: UInt {
        return 1
    }
}

extension Float: ZeroOne {
    public static var zero: Float {
        return 0
    }
    public static var one: Float {
        return 1
    }
}

extension Double: ZeroOne {
    public static var zero: Double {
        return 0
    }
    public static var one: Double {
        return 1
    }
}
