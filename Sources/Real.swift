
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
