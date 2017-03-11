
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

extension NDArray {
    public static func filled(with value: T, shape: [Int]) -> NDArray<T> {
        let elements = [T](repeating: value, count: shape.reduce(1, *))
        return NDArray(shape: shape, elements: elements)
    }
}

extension NDArray where T: ZeroOne {
    public static func zeros(_ shape: [Int]) -> NDArray<T> {
        return NDArray.filled(with: T.zero, shape: shape)
    }
    
    public static func ones(_ shape: [Int]) -> NDArray<T> {
        return NDArray.filled(with: T.one, shape: shape)
    }
    
    public static func eye(_ size: Int) -> NDArray<T> {
        var identity = zeros([size, size])
        (0..<size).forEach { identity[$0, $0] = T.one }
        return identity
    }
}

extension NDArray where T: Strideable {
    public static func range(from: T, to: T, stride: T.Stride) -> NDArray<T> {
        let elements = Array(Swift.stride(from: from, to: to, by: stride))
        return NDArray(shape: [elements.count], elements: elements)
    }
}

extension NDArray where T: FloatingPoint {
    public static func linspace(low: T, high: T, count: Int) -> NDArray<T> {
        let d = high - low
        let steps = T(count-1)
        let elements = (0..<count).map { low + T($0)*d/steps }
        return NDArray(shape: [count], elements: elements)
    }
}
