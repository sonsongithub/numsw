public protocol FloatProtocol {
    var value: Float { get }
}

public protocol DoubleProtocol {
    var value: Double { get }
}

extension Float: FloatProtocol {
    public var value: Float {
        return self
    }
}

extension Double: DoubleProtocol {
    public var value: Double {
        return self
    }
}
